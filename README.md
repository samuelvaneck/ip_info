# IP Info

A small Sinatra app that returns the requesting client's external IP. Browsers see a map with city/ISP details; CLI clients get a clean plain-text response.

The app uses the MaxMind GeoLite2-City and GeoLite2-ASN databases. Download them from MaxMind:

```
curl -I 'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=GEO_IP_LICENSE_KEY&suffix=tar.gz'
```

## Curl usage

Plain-text IP (curl, wget, HTTPie, fetch, etc. detected via `User-Agent`):

```
$ curl https://your-host/
1.2.3.4
```

Individual fields:

```
$ curl https://your-host/country
Netherlands

$ curl https://your-host/city
Amsterdam

$ curl https://your-host/isp
Example ISP B.V.
```

Full JSON response (also returned for any non-browser client other than curl-likes):

```
$ curl https://your-host/json
{
  "ip": "1.2.3.4",
  "country": "Netherlands",
  "coordinate": { "latitude": 52.37, "longitude": 4.89 },
  "city": "Amsterdam",
  "isp": "Example ISP B.V."
}
```

Look up another IP:

```
$ curl 'https://your-host/?ip=8.8.8.8'
$ curl 'https://your-host/json?ip=8.8.8.8'
```

## Run with Docker

```
# build
docker build --tag ip .

# run
docker run -p 80:4567 ip

# push image
./build_push.sh
```

## Run in development

```
bundle exec rerun -b -- rackup
```
