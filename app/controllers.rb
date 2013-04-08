Whodoesnotfollowme::App.controller do
    register Padrino::Admin::Helpers::AuthenticationHelpers

    get :index do
      redirect '/back'
    end

    get :back do
      @is_auth = !session[:id].nil?
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

        erik = Twitter::Client.new(
          :oauth_token => account.oauth_key,
          :oauth_token_secret => account.oauth_secret
        )
        
        friends = Array.new
        followers = Array.new 

        erik.follower_ids(name).each do |user| followers.push(user) end
        erik.friend_ids(name).each do |user| friends.push(user) end

        unfollowers = (friends - followers).each_slice(100).to_a

        u_unfollowers = Array.new
        unfollowers.each do |arr| erik.users(arr).each do |user| u_unfollowers.push({"avatar" => user.profile_image_url, "name" => user.name, "screen_name" => user.screen_name }) end end

        rescue Twitter::Error::TooManyRequests => error
          return {:msg => "Too many attempts. Please try again in 15 minutes."}.to_json 
        rescue
          return {:msg => "Something went wrong"}
        end

        u_unfollowers.to_json

    end

end
