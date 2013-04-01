#!/usr/bin/env ruby

require 'rubygems'
require "logger"
require "yaml"
require 'twitter'
require 'active_record'

class UnFollower
  
  def initialize(output = STDOUT, level = Logger::INFO)
    
    Twitter.configure do |config|
      config.consumer_key = '0OGA41vEkr7h4vjlF0tc3Q'
      config.consumer_secret = '2xmrPnxfRnBma3X6UYLdn1mjs9yKeG8ZqapI3El8k8'
    end 
    
    @log = Logger.new(output)
    @log.sev_threshold = level
    @log.formatter = Logger::Formatter.new
    
  end
  
  def start
   erik = Twitter::Client.new(
      :oauth_token => "14098468-w8rzIAiXDqLHPru1dbEQVWC33pBwNEhYAodyChj3A",
      :oauth_token_secret => "YrmSc5fyvpRx0pLOMsgHXY01PhXR3sYXRSyXvI9g"
    ) 
    
    friends = Array.new
    followers = Array.new
    
    erik.follower_ids("@lupittar").each do |user| followers.push(user) end
    erik.friend_ids("@lupittar").each do |user| friends.push(user) end

    unfollowers = (friends - followers).each_slice(100).to_a

    u_unfollowers = Array.new

    unfollowers.each do |arr| erik.users(arr).each do |user| u_unfollowers.push({"avatar" => user.profile_image_url, "name" => user.name, "screen_name" => user.screen_name }) end end

    puts u_unfollowers
  end
end

if $0 == __FILE__
  UnFollower.new(*ARGV).start
end
