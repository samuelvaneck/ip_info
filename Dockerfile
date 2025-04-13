FROM --platform=linux/amd64 ruby:3.4.2-alpine3.21

RUN apk update
RUN apk upgrade
RUN apk --no-cache add build-base
RUN apk --no-cache add curl

RUN bundle config set deployment 'true'

WORKDIR /app
COPY . /app
RUN bundle config set --local without 'development'
RUN bundle install

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]
