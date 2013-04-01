module OmniauthInitializer
  def self.registered(app)
    app.use OmniAuth::Builder do
      provider :developer unless Padrino.env == :production
      provider :twitter, '0OGA41vEkr7h4vjlF0tc3Q', '2xmrPnxfRnBma3X6UYLdn1mjs9yKeG8ZqapI3El8k8'
      # provider :facebook, 'app_id', 'app_secret'
    end

  end
end
