#!/bin/bash

# Set environment variable.
SCRIPT_FOLDER=~/github/scripts
DOCKER_FOLDER=~/github/docker
RCLONE_FOLDER=~/.config/rclone

# Copy the script to install docker to the virtual machine.
scp ${SCRIPT_FOLDER}/install/docker.sh aws:~

# Copy the files to launch the PostgreSQL and Trino containers.
scp ${DOCKER_FOLDER}/compose-aws.yml aws:~/compose.yml
scp -r ${DOCKER_FOLDER}/trino/catalog aws:~/trino-catalog

# Copy the config file and the script to install the Docker Volume Plugin.
scp ${RCLONE_FOLDER}/rclone.conf aws:~
scp ${DOCKER_FOLDER}/rclone-plugin.sh aws:~
