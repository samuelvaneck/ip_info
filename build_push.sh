docker build -t ghcr.io/samuelvaneck/ip:latest .
echo $CR_PAT | docker login ghcr.io --username samuelvaneck --password-stdin
docker tag ghcr.io/samuelvaneck/ip:latest
docker push ghcr.io/samuelvaneck/ip:latest
