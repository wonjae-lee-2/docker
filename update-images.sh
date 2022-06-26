#!/bin/bash

read -p "Which docker image would you like to rebuild with latest packages? " INPUT
echo

# Set environment variables.
SCRIPT_FOLDER=~/github/scripts

# Update packages.
$SCRIPT_FOLDER/packages/$INPUT.sh

# Stop the container.
docker stop docker-$INPUT-1

# Remove the container.
docker rm docker-$INPUT-1

# Remove the image.
docker rmi $(docker images */$INPUT -q)

# Build the image.
docker compose build --no-cache $INPUT
