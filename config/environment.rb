require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'

require_relative './appsignal'
require_relative './sidekiq'

require_relative '../apps/web/application'

require 'ett_de'
require 'ett_de/middlewares/appsignal_url_rack'
require 'pg'
require 'pry'

Hanami.configure do
  middleware.use AppsignalURLRack
  middleware.use Appsignal::Rack::GenericInstrumentation
  mount Web::Application, at: '/'

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/ett_de_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/ett_de_development'
    #    adapter :sql, 'mysql://localhost/ett_de_development'
    #
    adapter :sql, ENV.fetch('DATABASE_URL') || ENV.fetch('POSTGRES_URL')

    gateway { |g| g.connection.extension(:pg_json) }

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema 'db/schema.sql'
  end

  mailer do
    root 'lib/ett_de/mailers'

    # See https://guides.hanamirb.org/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: https://guides.hanamirb.org/projects/logging
    logger level: :debug
  end

  environment :production do
    logger level: :info, formatter: :json, filter: []

    # mailer do
    #   delivery :smtp, address: ENV.fetch('SMTP_HOST'), port: ENV.fetch('SMTP_PORT')
    # end
  end
end
