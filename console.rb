require 'bundler/setup'
require 'pry'

ENV['POSTGRES_URL'] =
  'postgres://postgres:postgres@postgres:5432/ett_de_production'
ENV['RABBITMQ_URL'] = 'amqp://guest:guest@rabbitmq:5672'
ENV['REDIS_URL'] = 'redis://redis:6379'
ENV['ENV'] = 'development'
ENV['HANAMI_ENV'] = 'development'
ENV['PGPASSWORD'] = 'postgres'

require 'config/boot'
binding.pry
