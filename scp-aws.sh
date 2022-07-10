#!/bin/bash

# Set environment variable.
SCRIPT_FOLDER=~/github/scripts
DOCKER_FOLDER=~/github/docker

# Copy the script to install docker to the virtual machine.
scp ${SCRIPT_FOLDER}/install/docker.sh aws:~

# Copy the files to launch the PostgreSQL and Trino containers.
scp ${DOCKER_FOLDER}/compose-aws.yml aws:~/compose.yml
scp -r ${DOCKER_FOLDER}/trino/catalog aws:~/trino-catalog
