#!/bin/bash
echo 'Switching dockerhub account'
rm ~/.docker/config.json && cp ~/.docker/config.json.awslabca ~/.docker/config.json

echo 'Stopping awscli container...'
docker stop awscli
echo 'Removing awscli container image...'
docker rmi -f awslabca/aws-cli-env

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

docker build -t awslabca/aws-cli-env:latest -t awslabca/aws-cli-env:`date "+%Y%m%d"`.1 . --push
