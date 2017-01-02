Unsplash.configure do |config|    
  config.application_id     = ENV['APPLICATION_ID']
  config.application_secret = ENV['APPLICATION_SECRET']
  config.application_redirect_uri = "https://localhost-current.ly"
end