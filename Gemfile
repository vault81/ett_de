source 'https://rubygems.org'

gem 'rake'
gem 'hanami', '~> 1.3'
# gem 'hanami-model', '~> 1.3'
gem "hanami-model", git: "https://github.com/hanami/model.git", require: false
gem 'warning'
gem 'faraday'
gem 'oj'
gem 'sidekiq'

group :development do
  # Code reloading
  # See: https://guides.hanamirb.org/projects/code-reloading
  gem 'shotgun', platforms: :ruby
  gem 'hanami-webconsole'
end

group :test, :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'dotenv', '~> 2.4'
end

group :test do
  gem 'rspec'
  gem 'capybara'
end

group :production do
  gem 'puma'
  gem 'pg'
end
