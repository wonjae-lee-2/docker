#!/bin/bash

# Ask for the desired number of workers to create.
echo
read -p "How many workers would you like to create? " NUM_WORKERS

# Copy the SSH private key to the `.ssh` folder.
cp ~/keys/id_ed25519 ~/.ssh

# Update the `deployment.yml` with the desired numer of workers.
sed -i "s/replicas:.*$/replicas: ${NUM_WORKERS}/g" deployment.yml

# Create worker pods.
kubectl apply -f deployment.yml

# Wait until all worker pods are ready.
kubectl wait deployment/worker -n julia --for=condition=Available --timeout=600s

# Wait few more seconds to make sure all the pods are ready.
sleep 10

# Set parameters for the loop.
i=1
POD_NAMES=$(kubectl get pods -n julia -o jsonpath="{.items[*].metadata.name}")

# Forward ports to all pods for SSH.
for POD_NAME in ${POD_NAMES}
do
    kubectl port-forward -n julia pod/${POD_NAME} $((60000 + i)):22 &
    i=$((i + 1))
done
