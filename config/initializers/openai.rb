OpenAI.configure do |config|
  api_key = Rails.env.production? ? ENV['OPENAI_SECRET_KEY'] : Rails.application.credentials.openai[:secret_key]
  config.access_token = api_key
end

