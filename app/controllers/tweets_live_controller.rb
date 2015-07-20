class TweetsLiveController < WebsocketRails::BaseController
  def start_new
    controller_store[:clients] ||= []
    controller_store[:clients] << current_user.uid if current_user
    connection_store[:uid] = current_user.uid if current_user
    restart_threads
  end

  def disconnect
    if connection_store[:uid]
      controller_store[:clients].reject! do |client|
        client == connection_store[:uid]
      end
    end
    restart_threads
  end

  def restart_threads
    p controller_store[:clients]
    if controller_store[:thread]
      controller_store[:thread].values.each do |thread|
        thread.exit
      end
      controller_store[:thread] = {}
    end
    return if controller_store[:clients].empty?
    controller_store[:thread] ||= {}
    controller_store[:clients].each do |client|
      client_user = User.find_by_uid(client)
      next if client_user.nil?
      controller_store[:thread][client] = Thread.new do
        begin
          controller_store[:twitter_streaming] ||= {}
          controller_store[:twitter_streaming][client] = client_user.twitter_stream
          controller_store[:twitter_streaming][client].user do |object|
            case object
            when Twitter::Tweet
              handle_tweet(object, client_user.uid)
            end
          end
        rescue Twitter::Error => e
          controller_store[:clients].each do |client|
            WebsocketRails["tweets_#{client}"].trigger 'streaming_error', { message: e.message }
          end
        end
      end
    end
  end

  private

  def handle_tweet(tweet, uid)
    tweet_obj = { full_text: tweet.full_text, user_name: tweet.user.name, created_at: tweet.created_at }
    WebsocketRails["tweets_#{uid}"].trigger 'new_tweet', tweet_obj
  end
end
