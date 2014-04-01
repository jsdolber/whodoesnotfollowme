Whodoesnotfollowme::App.controller do
    register Padrino::Admin::Helpers::AuthenticationHelpers
    register Padrino::Sprockets
    sprockets :minify => (Padrino.env == :production)
    
    get :index do
      redirect '/back'
    end

    get :back do
      @is_auth = !session[:id].nil?
      @recent_unfollowers = Unfollower.sample_unfollowers
      render 'index'
    end

    get :destroy do
      session[:id] = nil
      redirect url(:index)
    end

    get :auth, :map => '/auth/:provider/callback' do
        auth    = request.env["omniauth.auth"]
        account = Account.first(:provider => auth["provider"], :uid => auth["uid"]) || 
              Account.create_with_omniauth(auth)
        session[:id] = account.id
        redirect "http://" + request.env["HTTP_HOST"] + url(:back)
    end

    post :unfollowers do
        content_type :json

        return {:msg => "Invalid session"}.to_json if session[:id].nil?
        return {:msg => "Please input a twitter username."}.to_json if params[:name].nil? || params[:name].to_s.length == 0
         
        name = (params[:name].start_with? '@')? params[:name] : '@' + params[:name]
        account = Account.first(:id => session[:id]) 
        
        u_unfollowers = Array.new
 
        begin

        # erik = Twitter::Client.new(
        #   :oauth_token => account.oauth_key,
        #   :oauth_token_secret => account.oauth_secret
        # )

        erik = Twitter::REST::Client.new do |config|
          config.consumer_key = '0OGA41vEkr7h4vjlF0tc3Q'
          config.consumer_secret = '2xmrPnxfRnBma3X6UYLdn1mjs9yKeG8ZqapI3El8k8'
          config.access_token        = account.oauth_key
          config.access_token_secret = account.oauth_secret
        end
        
        friends = Array.new
        followers = Array.new 

        erik.follower_ids(name).each do |user| followers.push(user) end
        erik.friend_ids(name).each do |user| friends.push(user) end

        unfollowers = (friends - followers).each_slice(100).to_a

        u_unfollowers = Array.new

        unfollowers.each do |arr| 
          erik.users(arr).each do |user| 
            last_tweet = erik.user_timeline(user.screen_name, :count => 1).last
            last_tweet_text = last_tweet.nil? ? '' : last_tweet.text
            u_unfollowers.push({"avatar" => user.profile_image_url, 
                                  "name" => user.name, 
                                  "screen_name" => user.screen_name,
                                  "last_tweet" =>  last_tweet_text})
          end 
        end

        rescue Twitter::Error::TooManyRequests => error
          return {:msg => "Too many attempts. Please try again in 15 minutes."}.to_json 
        rescue Exception => e
          return {:msg => e.message }.to_json
        end

        Unfollower.create_or_update(u_unfollowers)

        u_unfollowers.to_json

    end

end
