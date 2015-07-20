// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require websocket_rails/main
//= require turbolinks
//= require_tree .


dispatcher = new WebSocketRails('localhost:3000/websocket')
channel = dispatcher.subscribe('tweets_' + window.currentUserUid)
channel.bind('new_tweet', drawTweet)

function drawTweet(tweet) {
  $('#tweets').prepend('<li>' + tweet.full_text + '<br>' + tweet.user_name + ' ' + tweet.created_at + '</li>');
}

function drawTweets(tweets) {
  for (var i=0; i<tweets.length; i++) {
    var tweet = tweets[i];
    drawTweet(tweet);
  }
}

function getTweets() {
  $.ajax({
    url: '/tweets',
    success: function (tweets) {
      drawTweets(tweets);
    }
  });
}

getTweets()
