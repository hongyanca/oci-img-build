#!/bin/bash
echo 'Switching dockerhub account'
rm ~/.docker/config.json && cp ~/.docker/config.json.awslabca ~/.docker/config.json

echo 'Stopping dev-container...'
sudo systemctl stop code-server.service
docker stop code-server
docker stop cloudflared-tunnel-code-server
echo 'Removing dev-container image...'
docker rmi -f awslabca/dev-container-x64
docker rmi -f lscr.io/linuxserver/code-server

echo 'Removing all unused data...'
docker builder prune --all --force
docker system prune --all --volumes --force
# Check for dangling Docker volumes
dangling_volumes=$(docker volume ls -qf dangling=true)
# If there are dangling volumes, remove them
if [ ! -z "$dangling_volumes" ]; then
	echo "Removing dangling Docker volumes..."
	sudo docker volume rm $dangling_volumes
else
	echo "No dangling Docker volumes found."
fi

# docker build -t awslabca/dev-container:latest -t awslabca/dev-container:`date "+%Y%m%d"`.1 . --push
docker build -f Dockerfile-x64 -t awslabca/dev-container-x64:latest . --push
docker build -f Dockerfile-x64 -t awslabca/dev-container-x64:$(date "+%Y%m%d").1 . --push

cd /apps/code-server
/usr/bin/docker-compose pull
sudo docker builder prune --all --force
sudo docker system prune --all --volumes --force
sudo systemctl start code-server.service
