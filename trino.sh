#!/bin/bash

# Get user input for software versions.
echo
read -p "What is your PostgreSQL password? " INPUT_PSQL_PASSWORD

# Replace password in `template-values.yml` to generate `values.yml`.
sed -e "s/INPUT_PSQL_PASSWORD/${INPUT_PSQL_PASSWORD}/g" \
    trino/helm/template-values.yml > trino/helm/values.yml

# Add the trino helm chart repository.
helm repo add trino https://trinodb.github.io/charts/

# Install the trino helm chart with the customized values.yml.
helm install -n trino -f ~/github/docker/trino/helm/values.yml trino trino/trino

# Wait until the coordinator is deployed.
kubectl wait deployment/trino-coordinator -n trino --for=condition=Available --timeout=600s

# Wait few more seconds to make sure the coordinator is running.
sleep 10

# Show the external IP address of the load balancer for Web UI.
kubectl get services -n trino

# Launch the Trino command line interface.
kubectl exec -n trino -it service/trino -- trino

# Uninstall the trino helm chart.
#helm uninstall trino

# Update the trino helm chart repo.
#helm repo update

# Upgrade the installed trino helm chart.
#helm upgrade -f trino/helm/values.yml trino trino/trino
