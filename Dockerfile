FROM ruby:3.1.1-alpine3.15

RUN apk --update add --no-cache build-base curl curl-dev

RUN bundle config set deployment 'true'

WORKDIR /app
COPY . /app
RUN bundle install --without development

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]
