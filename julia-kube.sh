#!/bin/bash

# Start a Julia container.
kubectl apply -f julia-pod.yml

# Wait until the container displays the token for Jupyter Lab.
while ! kubectl logs julia
do
    echo "Waiting for the container to start..."
    echo
    sleep 10
done

# Sync the github folder with the container.
devspace sync --local-path=/home/ubuntu/github --container=julia --container-path=/home/julia/github
