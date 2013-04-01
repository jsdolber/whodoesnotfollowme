module AnalyticsInitializer
  def self.registered(app)
    app.use Rack::GoogleAnalytics, :tracker => 'UA-xxxxxx-x'

  end
end
