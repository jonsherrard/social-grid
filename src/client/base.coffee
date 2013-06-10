# Namespace
promise = require 'when'
sequence = require("when/sequence")
parallel = require("when/parallel")


class SocialGrid

	dimensions :
		baseHeight : 0

	creds :
		instagram :
			clientId : "5b3bafe2ba6a4f82a09dbb65d889e2cb"
	
	strings :
		picture : (url, imageHeight) =>
			return "<img class='sg-instagram-picture' src='#{url}' height='#{imageHeight}'/>"
		container : (height) ->
            return "<div id='sg-container', style='height:#{height}px'></div>"
        tweet : (tweet, tweetWidth, tweetHeight) ->
            return "<div class='sg-twitter-tweet' style='width:#{tweetWidth}px;height:#{tweetHeight}px;'><span class='sg-tweet-text'>#{tweet}</span></div>"

	init : (height) =>
		@dimensions.baseHeight = height
		$('#social-grid').append @strings.container @dimensions.baseHeight
		@twitter 'wongagillian'
		@instagram 'wonga'

	instagram : (username) =>
		instagramUrlString = "https://api.instagram.com/v1/tags/#{username}/media/recent?client_id=#{@creds.instagram.clientId}"
		ajaxopts =
			url : instagramUrlString
			type : 'GET'
			dataType : 'jsonp'
			success : (data) => @parsePictures data
		$.ajax ajaxopts, error: -> console.log "failed"

	parsePictures : (pictures) =>
		for pic in pictures.data
			$('#sg-container').append @strings.picture pic.images.low_resolution.url, @dimensions.baseHeight/4

	twitter : (username) =>
		twitterDfd = promise.defer()
		twitterUrlString = "http://search.twitter.com/search.json?q=from%3a#{username}"
		ajaxopts =
			url : twitterUrlString
			type : 'GET'
			dataType : 'jsonp'
			success : (data) => @parseTweets data
		$.ajax ajaxopts, error: -> console.log 'failed'

	parseTweets : (tweets) =>
        for tweet in tweets.results
		   # text, width, height
           $('#sg-container').append @strings.tweet tweet.text, @dimensions.baseHeight/2, @dimensions.baseHeight/2

		



window.SocialGrid = SocialGrid

twitterCallback = ->
    alert 'yes!'

