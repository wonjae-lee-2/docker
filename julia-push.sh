#!/bin/bash

# Get user input for the Julia version.
echo
read -p "Which version of Julia image would you like to push to the artifact registry? " JULIA_VERSION

# Set environment variables.
PROJECT_ID=project-lee-1
ARTIFACT_REGISTRY=us-central1-docker.pkg.dev/${PROJECT_ID}/docker

# Re-tag the Julia image.
docker tag docker/julia:${JULIA_VERSION} ${ARTIFACT_REGISTRY}/julia:${JULIA_VERSION}

# Push the image to the artifact registry.
docker push ${ARTIFACT_REGISTRY}/julia:${JULIA_VERSION}

# Untag the image.
docker rmi ${ARTIFACT_REGISTRY}/julia:${JULIA_VERSION}

# Update the `julia-pod.yml`.
sed -i "s/julia:.*$/julia:${JULIA_VERSION}/g" julia-pod.yml
