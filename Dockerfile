FROM ruby:3.1.2-alpine3.15

RUN apk update
RUN apk upgrade
RUN apk --no-cache add build-base
RUN apk --no-cache add curl

RUN bundle config set deployment 'true'

WORKDIR /app
COPY . /app
RUN bundle install --without development

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]
