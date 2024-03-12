source "https://rubygems.org"

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

gem "dockerfile-rails", ">= 1.5", :group => :development

gem "sentry-ruby", "~> 5.14"
gem "sentry-rails", "~> 5.14"

# sorceryの導入
gem 'sorcery', "0.16.5"

# 定数管理
gem 'config'

# tailwindcssの導入
gem "tailwindcss-rails", "~> 2.0"

# Hotwireの導入
gem 'turbo-rails'
gem 'stimulus-rails'

# 画像投稿gem
gem 'carrierwave', '~> 3.0'

# i18nのgem
gem 'rails-i18n', '~> 7.0.0'

# enum定義のgem
gem 'enum_help'

# API導入に伴うgem
gem 'faraday'
gem 'googleauth'

# 本番環境での画像保存用gem
gem "aws-sdk-s3"
gem "carrierwave-aws"

# ページネーション
gem 'kaminari'

# 検索機能
gem 'ransack'

# Active Jobのアダプタの設定
gem 'sidekiq'

# Open AIの導入
gem "ruby-openai"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem 'faker'
  gem 'factory_bot_rails'
  gem "rubocop"
  gem "rubocop-rails"
  gem 'rubocop-checkstyle_formatter'
  gem 'pry-remote'
  gem 'rspec-rails'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem 'bullet'
  gem 'letter_opener_web'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

end

group :test do
  gem 'capybara'
  gem 'webdrivers'
end