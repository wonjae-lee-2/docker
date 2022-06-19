#!/bin/bash

read -p "How many seconds would you like to wait before the container starts? " INPUT

# Start a Julia container.
kubectl apply -f julia-service.yml -f julia-pod.yml

# Wait for the container to run.
sleep $INPUT

# Show the token of Jupyter Lab in the container.
kubectl logs julia

# Show the public IP address of the node.
gcloud compute instances list

# Sync the github folder with the container.
devspace sync --local-path=/home/ubuntu/github --container=julia --container-path=/home/github
