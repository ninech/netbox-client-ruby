FROM ruby:2.3.4-alpine

RUN apk add --no-cache git

RUN mkdir /app
WORKDIR /app

COPY . ./
RUN bundle install --jobs 4 --quiet --deployment

CMD docker/start.sh
