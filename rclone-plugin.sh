#!/bin/bash

# Ask for user input for the version of Rclone Docker Volume Plugin to install.
echo
echo "Check the latest version of Rclone Plugin. https://hub.docker.com/r/rclone/docker-volume-rclone/"
read -p "Which tag of Rclone Plugin would you like to install? " RCLONE_PLUGIN_TAG

# Install dependencies.
sudo apt update
sudo apt-get -y install fuse

# Create two directories required by the plugin.
sudo mkdir -p /var/lib/docker-plugins/rclone/config
sudo mkdir -p /var/lib/docker-plugins/rclone/cache

# Copy the configuration file to whre the plugin can load it.
sudo cp ~/.config/rclone/rclone.conf /var/lib/docker-plugins/rclone/config

# Install the plugin.
docker plugin install rclone/docker-volume-rclone:${RCLONE_PLUGIN_TAG} --alias rclone --grant-all-permissions args="-v --allow-other --vfs-cache-mode=writes"
