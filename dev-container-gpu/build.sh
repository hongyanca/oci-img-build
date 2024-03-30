#!/bin/bash
echo 'Switching dockerhub account'
rm ~/.docker/config.json && cp ~/.docker/config.json.awslabca ~/.docker/config.json

echo 'Stopping dev-container-gpu...'
docker stop cloudflared-tunnel-dev-container-gpu
docker stop dev-container-gpu
sudo systemctl stop dev-container-gpu.service
echo 'Removing dev-container-gpu image...'
docker rmi -f awslabca/dev-container-gpu:latest

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

#docker build -t awslabca/dev-container-gpu:latest .
docker build -t awslabca/dev-container-gpu:latest . --push

cd /data/apps/dev-container-gpu
/usr/bin/docker-compose pull
sudo systemctl start dev-container-gpu.service
