class Account
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :email, String
  property :role, String
  property :uid, String
  property :provider, String
  property :oauth_key, String
  property :oauth_secret, String

  def self.create_with_omniauth(auth)
    Account.create(:provider => auth["provider"], 
                    :uid => auth["uid"], 
                    :email => auth["name"], 
                    :role => "users",
                    :oauth_key => auth['credentials']['token'],
                    :oauth_secret => auth['credentials']['secret'])
  end
end
