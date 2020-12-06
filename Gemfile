source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'
#ruby-gemset=@prorails

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# gem 'webpacker', '~> 4.0'
gem 'uglifier', '>= 1.3.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
gem 'diff-lcs', '~> 1.2.5'
gem 'slim-rails'
gem 'devise'
# gem 'twitter-bootstrap-rails'
gem 'bootstrap', '~> 4.2.1'
gem 'jquery-rails'
gem 'aws-sdk-s3', require: false
gem 'cocoon'
gem 'validate_url'

gem "octokit", "~> 4.0"
gem 'octicons_helper'
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.4'

# Get your Rails variables in your js
gem 'gon'
gem 'skim', '~> 0.10.0'

# Helper for creating declarative interfaces in controllers
gem 'decent_exposure', '3.0.0'

gem 'responders'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-vkontakte'

gem 'cancancan'
gem 'pundit'

gem 'doorkeeper', '>= 5.0'
gem 'active_model_serializers', '~> 0.10'
gem 'oj'

# Tool for background tasks that uses Redis as a database
gem 'sidekiq'
# Interface for sidekiq
gem 'sinatra', require: false
# Cron jobs in Ruby
gem 'whenever', require: false

# Thinking Sphinx is a library for connecting ActiveRecord to the Sphinx full-text search tool
gem 'mysql2'
gem 'thinking-sphinx'
gem 'mini_racer'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0.1'
  gem 'factory_bot_rails'
  gem 'letter_opener'
  gem 'launchy'
  # Clean your ActiveRecord databases with Database Cleaner
  gem 'database_cleaner-active_record'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false

end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  # gem 'chromedriver-helper'
  gem 'webdrivers'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  # gem 'launchy'
  gem 'capybara-email'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
