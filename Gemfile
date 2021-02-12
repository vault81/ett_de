source 'https://rubygems.org'

gem 'appsignal'
gem 'rake'
gem 'hanami', '~> 1.3'

# gem 'hanami-model', '~> 1.3'
gem 'hanami-model', git: 'https://github.com/hanami/model.git', require: false
gem 'warning'
gem 'faraday'
gem 'oj'
gem 'sidekiq'
gem 'dotenv', '~> 2.4'
gem 'sequel'
gem 'sequel_pg', require: false

group :development do
  # Code reloading
  # See: https://guides.hanamirb.org/projects/code-reloading
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'shotgun', platforms: :ruby
  gem 'solargraph'
  gem 'hanami-webconsole'
end

group :test, :development do
  gem 'sqlite3'
  gem 'pry'
end

group :test do
  gem 'rspec'
  gem 'capybara'
end

group :production do
  gem 'puma'
  gem 'pg'
end
