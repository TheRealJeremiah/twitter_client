# How to run locally
- Add twitter_api_key, twitter_api_secret to secrets.yml
- make your twitter app callback point to 127.0.0.1:3000/auth/twitter/callback
- 'rails s'
# Description of implementation
I used omniauth-twitter for user authentication and the twitter REST api to allow users to make posts in a straightforward way. The tricky part was live updates using websockets. A new thread is created for every currently visiting user, and a twitter user stream connection is maintained in this thread. Upon receiving a tweet, and event will be broadcast to the channel corresponding to that user. On the client side, the tweet will be received in the subscribed channel and added to the page with jQuery.
