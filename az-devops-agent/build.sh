#!/bin/bash
echo 'Switching dockerhub account'
cp ~/.docker/config.json /tmp/docker_backup_config.json
rm -f ~/.docker/config.json && cp ~/.docker/config.json.homeryan ~/.docker/config.json

echo 'Stopping az-devops-agent...'
sudo systemctl stop az-devops-agent.service
docker stop az-devops-agent
echo 'Removing az-devops-agent image...'
docker rmi -f homeryan/az-devops-agent

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

docker build -t homeryan/az-devops-agent:latest -t homeryan/az-devops-agent:`date "+%Y%m%d"`.1 . --push

rm -f ~/.docker/config.json && cp /tmp/docker_backup_config.json ~/.docker/config.json
rm -f /tmp/docker_backup_config.json

sudo systemctl start az-devops-agent.service
