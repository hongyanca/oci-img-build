#!/bin/bash
# Check if the Docker container is already running
if [ ! "$(docker ps -q -f name=awscli)" ]; then
    # If the container doesn't exist, run the Docker container
    docker run -it --rm --name awscli -d awslabca/aws-cli-env:latest
else
    echo "Container 'awscli' is already running."
fi

docker exec -it --user root awscli /usr/bin/zsh
