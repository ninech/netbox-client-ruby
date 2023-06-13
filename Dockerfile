ARG RUBY_VERSION=3.2.2
FROM ruby:${RUBY_VERSION}-alpine

RUN apk add --no-cache git openssl-dev build-base

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock netbox-client-ruby.gemspec VERSION ./
RUN bundle install --jobs 4 --deployment --quiet

COPY . ./

CMD docker/start.sh
