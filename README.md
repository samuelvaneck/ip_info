# Ruby Sinatra app to get Extranal IP

Small Sinatra app to get the extranal IP of a the request

The app use MaxMind GeoLite2-City database. Download it from their website.

```
curl -I 'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=GEO_IP_LICENSE_KEY&suffix=tar.gz'
```

Run with docker:
```
  # build docker container:
  docker build --tag ip .

  # run docker container:
  docker run -p 80:4567 ip

  # push not image to repository
  ./build_push.sh
```

Run in development:
```
  ruby lib/app.rb
```

Get the extrnal IP address
```
  curl http://localhost:4567
```
