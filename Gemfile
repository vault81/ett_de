source 'https://rubygems.org'

gem 'appsignal'
gem 'dotenv', '~> 2.4'
gem 'faraday'
gem 'faraday_middleware'
gem 'hanami', '~> 1.3'

# gem 'hanami-model', '~> 1.3'
gem 'hanami-model', git: 'https://github.com/hanami/model.git', require: false
gem 'oj'
gem 'rake'
gem 'sequel'
gem 'sequel_pg', require: false
gem 'sidekiq'
gem 'warning'
gem 'simple_jsonapi_client'

group :development do
  # Code reloading
  # See: https://guides.hanamirb.org/projects/code-reloading
  gem 'hanami-webconsole'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'shotgun', platforms: :ruby
end

group :test, :development do
  gem 'pry'
  gem 'solargraph'
  gem 'typespec'
  gem 'yard'
end

group :test do
  gem 'capybara'
  gem 'rspec'
end

group :production do
  gem 'pg'
  gem 'puma'
end
