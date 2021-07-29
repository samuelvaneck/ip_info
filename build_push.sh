docker build -t ghcr.io/samuelvaneck/ip_info:latest .
echo $CR_PAT | docker login ghcr.io --username samuelvaneck --password-stdin
docker tag ghcr.io/samuelvaneck/ip_info:latest
docker push ghcr.io/samuelvaneck/ip_info:latest
