FROM ruby:2.3.4-alpine
MAINTAINER development@nine.ch

RUN apk add --no-cache git

RUN mkdir /app
WORKDIR /app

COPY . ./
RUN bundle install --jobs 4 --quiet

CMD docker/start.sh
