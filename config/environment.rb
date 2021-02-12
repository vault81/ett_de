require 'bundler/setup'
require 'appsignal' # Load AppSignal
require 'hanami/setup'
require 'hanami/model'

require_relative '../lib/ett_de'
require_relative '../apps/web/application'
require_relative './sidekiq'
require 'pg'
require 'pry'

Appsignal.config =
  Appsignal::Config.new(
    Hanami.root,
    p(Hanami.env),
    name: 'ett_de' # Optional configuration hash
  )

p Appsignal.start # Start the AppSignal integration
Appsignal.start_logger # Start logger

class AppsignalURL
  def initialize(app, options = {})
    @app = app
    @options = options
  end

  def call(env)
    url = Rack::Request.new(env).url
    path = URI.parse(url).path
    env['appsignal.route'] =
      if path.start_with('/assets')
        '/assets'
      elsif path.start_with('/players')
        res('players')
      elsif path.start_with('/tournaments')
        res('tournaments')
      else
        path
      end

    @app.call(env)
  end

  private

  def res(name)
    if path.end_with(res)
      "/#{name}"
    elsif path.end_with('new')
      "/#{name}/new"
    else
      "/#{name}/:id"
    end
  end
end

Hanami.configure do
  middleware.use AppsignalURL
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
