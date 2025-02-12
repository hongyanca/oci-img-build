#!/usr/bin/env bash
echo 'Switching dockerhub account'
cp ~/.docker/config.json /tmp/docker_backup_config.json
rm -f ~/.docker/config.json && cp ~/.docker/config.json.homeryan ~/.docker/config.json

echo 'Stopping next-chat...'
sudo systemctl stop next-chat.service
docker stop next-chat
echo 'Removing next-chat image...'
docker rmi -f homeryan/next-chat:latest

echo 'Removing all unused data...'
docker builder prune --all --force
docker system prune --all --volumes --force
# Check for dangling Docker volumes
dangling_volumes=$(docker volume ls -qf dangling=true)
# If there are dangling volumes, remove them
if [ -n "$dangling_volumes" ]; then
  echo "Removing dangling Docker volumes..."
  sudo docker volume rm "$dangling_volumes"
else
  echo "No dangling Docker volumes found."
fi

echo "Cloning the repository..."
rm -rf ./NextChat
git clone --depth=1 --single-branch --branch main https://github.com/ChatGPTNextWeb/NextChat.git
sed -i 's/FROM node:18-alpine AS base/FROM node:lts-alpine AS base/' NextChat/Dockerfile
echo "Building the image..."
cd NextChat || exit
docker build -t homeryan/next-chat:latest -t homeryan/next-chat:"$(date '+%Y%m%d')".1 . --push

rm -f ~/.docker/config.json && cp /tmp/docker_backup_config.json ~/.docker/config.json
rm -f /tmp/docker_backup_config.json

sudo systemctl start next-chat.service
