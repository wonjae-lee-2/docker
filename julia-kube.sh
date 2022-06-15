#!/bin/bash

read -p "How many seconds would you like to wait before port-forwarding? " INPUT

kubectl apply -f julia-pod.yml

sleep $INPUT

kubectl port-forward julia 8888:8888 1234:1234 &

devspace sync --local-path=/home/ubuntu/github --container=julia --container-path=/home/github &

kubectl attach -it julia

pkill devspace

pkill kubectl
