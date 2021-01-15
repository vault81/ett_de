#!/bin/sh
RABBITMQ_TCP=$(echo $RABBITMQ_URL | sed -E "s/amqp:\/\/.+@/tcp:\/\//")
POSTGRES_TCP=$(echo $POSTGRES_URL | sed -E "s/postgres:\/\/.+@/tcp:\/\//")
REDIS_TCP=$(echo $REDIS_URL | sed -E "s/rediss?:\/\/(.*@)?/tcp:\/\//")

export DATABASE_URL=$POSTGRES_URL

dockerize -wait $POSTGRES_TCP \
          -wait $RABBITMQ_TCP \
          -wait $REDIS_TCP \
          -timeout 20s

if [ "$1" = "test" ]; then
  export ENV='test'
  set -e
  bundle exec hanami db prepare
  exec bundle exec rake
elif [ "$1" = "worker" ]; then
  createdb --host=postgres -w ett_de_production --user=postgres
  bundle exec hanami db migrate

  bundle exec ruby ./bin/refresh_players
elif [ "$1" = "run" ]; then
  createdb --host=postgres -w ett_de_production --user=postgres
  bundle exec hanami db migrate
  set -e

  exec bundle exec puma -p 8080
else
  exec "$@"
fi
