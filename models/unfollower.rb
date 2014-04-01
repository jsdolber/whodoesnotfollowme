class Unfollower
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :avatar_url, String
  property :name, String
  property :screen_name, String
  property :last_tweet, String
end
