class TweetsController < ApplicationController
  def index
    @timeline = current_user.twitter.home_timeline
    render :index
  end

  def create
    tweet = current_user.twitter.update(tweet_params[:body])
    render json: tweet
  end

  private

  def tweet_params
    params.require(:tweet).permit(:body)
  end
end
