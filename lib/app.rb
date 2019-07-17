#call gem twitter dotenv
require 'twitter'
require 'dotenv'
require 'pry'

#expand path
local_dir = File.expand_path('../', __FILE__)
$LOAD_PATH.unshift(local_dir)

#liste des journalistes
require 'list_journalists.rb'

#somewhere
Dotenv.load('.env')
 
# quelques lignes qui appellent les clés d'API de ton fichier .env
def login_twitter
    client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
    end
    return client
end
 
def login_streming_twitter
    stream = Twitter::Streaming::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
    end
    return stream
end

def pick_me_nb_in_array(array, nb=1)
    return array.sample(nb)
end

def send_tweet_from_send_to_rec(rec, send="")
    rec.each do |s|
        if rec == ""
            rec = "anonyme"
        end
        login_twitter.update("#Bonjour_monde, #{s} meri pour votre travail. from @#{send}")
    end
end

def give_like_to(liked)
    login_twitter.search(liked, result_type: 'recent').take(25).collect {|i| login_twitter.favorite(i)}
end

def give_follow_to(follow)
    login_twitter.search(follow, result_type: 'recent').take(25).collect {|i| login_twitter.follow(i.user)}
end

def live_give_like_and_follow_to(like_follow="")
    login_streming_twitter
    login_streming_twitter.filter(:track => like_follow) do |i| 
        login_twitter.follow(i.user)
        login_twitter.favorite(i)
    end
end

live_give_like_and_follow_to("#bonjour_monde")