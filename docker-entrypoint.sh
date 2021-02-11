#!/bin/sh
RABBITMQ_TCP=$(echo $RABBITMQ_URL | sed -E "s/amqp:\/\/.+@/tcp:\/\//")
POSTGRES_TCP=$(echo $POSTGRES_URL | sed -E "s/postgres:\/\/.+@/tcp:\/\//")
REDIS_TCP=$(echo $REDIS_URL | sed -E "s/rediss?:\/\/(.*@)?/tcp:\/\//")

export DATABASE_URL=$POSTGRES_URL

dockerize -wait $POSTGRES_TCP \
          -wait $REDIS_TCP \
          -timeout 20s

if [ "$1" = "test" ]; then
  export ENV='test'
  createdb --host=postgres -w ett_de_production --user=postgres
  set -e
  bundle exec hanami db migrate
  exec bundle exec rake
elif [ "$1" = "build_leagues" ]; then
  bundle exec rake seed:leagues
elif [ "$1" = "rebuild_leagues" ]; then
  bundle exec rake seed:clear_leagues
  bundle exec rake seed:leagues
elif [ "$1" = "worker" ]; then
  createdb --host=postgres -w ett_de_production --user=postgres
  bundle exec hanami db migrate

  bundle exec ruby ./bin/worker $2
elif [ "$1" = "run" ]; then
  createdb --host=postgres -w ett_de_production --user=postgres
  bundle exec hanami db migrate
  set -e

  exec bundle exec puma -p 8080
else
  exec "$@"
fi
