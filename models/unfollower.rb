class Unfollower
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :avatar_url, String
  property :name, String
  property :screen_name, String
  property :last_tweet, String

  def self.create_or_update(unfollowers)
  	unfollowers.sample(10).each do |uf|
  		u = Unfollower.first(:screen_name => uf["screen_name"])

  		if u.nil?
  			u = Unfollower.new(:avatar_url => uf["avatar"],
                              :name =>uf["name"],
                              :screen_name => uf["screen_name"])
  		end

  		u.last_tweet = uf["last_tweet"]

  		u.save!
  	end
  end

  def self.sample_unfollowers
  	unfollowers = []  	

  	Unfollower.all.sample(7).each do |uf|
		unfollowers.push({"avatar" => uf.avatar_url, 
                              "name" => uf.name, 
                              "screen_name" => uf.screen_name,
                              "last_tweet" =>  uf.last_tweet})
  	end

  	unfollowers.to_json
  end
end
