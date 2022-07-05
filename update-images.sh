#!/bin/bash

# Set environment variables.
SCRIPT_FOLDER=~/github/scripts

# Update packages.
$SCRIPT_FOLDER/packages/python.sh
$SCRIPT_FOLDER/packages/r.sh
$SCRIPT_FOLDER/packages/julia.sh

# Stop the container.
docker stop $(docker ps -aq)

# Remove the container.
docker rm $(docker ps -aq)

# Remove the image.
docker rmi $(docker images -q)

# Clear the cache.
docker system prune

# Build the image.
docker compose build --no-cache
