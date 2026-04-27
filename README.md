# IP Info

A small Sinatra app that returns the requesting client's external IP. Browsers see a map with city/ISP details; CLI clients get a clean plain-text response.

The app uses the MaxMind GeoLite2-City and GeoLite2-ASN databases. Download them from MaxMind:

```
curl -I 'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=GEO_IP_LICENSE_KEY&suffix=tar.gz'
```

## Curl usage

Use the `https://` URL — port 80 redirects to HTTPS and curl won't follow the redirect by default (you'd just see `Found`). Add `-L` if you prefer the bare hostname.

Plain-text IP (curl, wget, HTTPie, fetch, etc. detected via `User-Agent`):

```
$ curl https://ip.samuelvaneck.com/
1.2.3.4
```

Individual fields:

```
$ curl https://ip.samuelvaneck.com/country
Netherlands

$ curl https://ip.samuelvaneck.com/city
Amsterdam

$ curl https://ip.samuelvaneck.com/isp
Example ISP B.V.
```

Full JSON response (also returned for any non-browser client other than curl-likes):

```
$ curl https://ip.samuelvaneck.com/json
{
  "ip": "1.2.3.4",
  "country": "Netherlands",
  "country_code": "NL",
  "region": "North Holland",
  "region_code": "NH",
  "postal_code": "1012",
  "timezone": "Europe/Amsterdam",
  "coordinate": { "latitude": 52.37, "longitude": 4.89 },
  "city": "Amsterdam",
  "isp": "Example ISP B.V.",
  "asn": 12345
}
```

Look up another IP via the `?ip=` query param:

```
$ curl 'https://ip.samuelvaneck.com/?ip=8.8.8.8'
8.8.8.8

$ curl 'https://ip.samuelvaneck.com/json?ip=8.8.8.8'
{
  "ip": "8.8.8.8",
  "country": "United States",
  "country_code": "US",
  "timezone": "America/Chicago",
  "coordinate": { "latitude": 37.751, "longitude": -97.822 },
  "isp": "GOOGLE",
  "asn": 15169
}

$ curl 'https://ip.samuelvaneck.com/isp?ip=8.8.8.8'
GOOGLE
```

If a field can't be resolved (e.g. a private/unknown IP), the response is empty for the field endpoints, and the JSON endpoint omits the missing keys:

```
$ curl 'https://ip.samuelvaneck.com/json?ip=10.0.0.1'
{
  "ip": "10.0.0.1"
}
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
