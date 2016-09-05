Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Rails.application.secrets.twitter_api_key, Rails.application.secrets.twitter_api_secret
  warn '*' * 30
  warn "#{Rails.application.secrets.twitter_api_key} #{Rails.application.secrets.twitter_api_secret}"
  warn '*' * 30
end