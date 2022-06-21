#!/bin/bash

# Start a Julia container.
kubectl apply -f julia-pod.yml

# Show the token of Jupyter Lab in the container.
while ! kubectl logs julia
do
    sleep 10
done

# Sync the github folder with the container.
devspace sync --local-path=/home/ubuntu/github --container=julia --container-path=/home/julia/github
