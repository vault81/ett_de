FROM ruby:2.7.3-buster

RUN apt-get update && apt-get upgrade -y \
  && mkdir -p /usr/share/man/man1 \
  && mkdir -p /usr/share/man/man7 \
  && apt-get install -y wget openssl git

RUN groupadd -r app -g 1000
RUN useradd -u 1000 -r -g app -m -s /sbin/nologin app

WORKDIR /code

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY Gemfile /code
COPY Gemfile.lock /code
RUN chown -R app:app /code/

RUN apt-get install -y --no-install-recommends libsqlite3-dev build-essential libpq-dev postgresql-client \
  && bundle install \
  && apt-get purge -y build-essential \
  && apt-get -y autoremove

COPY . /code
RUN chown -R app:app /code/

USER app

EXPOSE 8080/tcp
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["run"]
