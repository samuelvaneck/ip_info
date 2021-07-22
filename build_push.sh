docker build -t ip:latest .
echo $CR_PAT | docker login ghcr.io --username samuelvaneck --password-stdin
docker tag radio_web ghcr.io/samuelvaneck/ip:latest
docker push ghcr.io/samuelvaneck/ip:latest
