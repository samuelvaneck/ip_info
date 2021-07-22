# Ruby Sinatra app to get Extranal IP

Small Sinatra app to get the extranal IP of a the request

Run with docker:
```
  # build docker container:
  docker build --tag ip .

  # run docker container:
  docker run -p 80:4567 ip
```

Run in development:
```
  ruby lib/ip.rb
```
