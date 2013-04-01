module RecatpchaInitializer
  def self.registered(app)
    app.use Rack::Recaptcha,
      :private_key => "YOUR_PRIVATE_KEY",
      :public_key => "YOUR_PUBLIC_KEY",
      :paths => "YOUR_LOGIN_PATH(S)"
    app.helpers Rack::Recaptcha::Helpers

  end
end
