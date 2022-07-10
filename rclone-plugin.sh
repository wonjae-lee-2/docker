#!/bin/bash

# Install dependencies.
sudo apt update
sudo apt-get -y install fuse

# Create two directories required by the plugin.
sudo mkdir -p /var/lib/docker-plugins/rclone/config
sudo mkdir -p /var/lib/docker-plugins/rclone/cache

# Ask the location of installation to identify the config file.
echo
read -p "Where are you installing the Docker Volume Plugin? (wsl or aws) " INSTALL_LOCATION

if [ ${INSTALL_LOCATION} = "wsl" ]
then
    # Copy the configuration file to whre the plugin can load it.
    sudo cp ~/.config/rclone/rclone.conf /var/lib/docker-plugins/rclone/config
elif [ ${INSTALL_LOCATION} = "aws" ]
then
    # Copy the configuration file to whre the plugin can load it.
    sudo mv ~/rclone.conf /var/lib/docker-plugins/rclone/config
fi

# Install the plugin.
docker plugin install rclone/docker-volume-rclone:amd64 --alias rclone --grant-all-permissions args="-v --allow-other"
