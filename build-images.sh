#!/bin/bash

# Get user input for the Spark and Julia version.
echo
read -p "Which version of Julia is in compose.yml? " JULIA_VERSION
echo
read -p "Which version of Spark would you like to build an image for? " SPARK_VERSION

# Set environment variables.
SPARK_FOLDER=/opt/spark/${SPARK_VERSION}
DOCKER_FOLDER=~/github/docker
ARTIFACT_REGISTRY=us-central1-docker.pkg.dev/project-lee-1/docker

# Build the images in the `compose.yml`.
docker compose build --no-cache

# Push the images in the `compose.yml`.
docker compose push

# Build a julia worker image for the kubernetes cluster.
docker build ${DOCKER_FOLDER}/julia-worker --build-arg JULIA_VERSION=${JULIA_VERSION} -t ${ARTIFACT_REGISTRY}/julia-worker:${JULIA_VERSION}

# Push the julia worker image to the artifact registry.
docker push ${ARTIFACT_REGISTRY}/julia-worker:${JULIA_VERSION}

# Update the `deployment.yml` in the julia sub-folder.
sed -i "s/julia-worker:.*$/julia-worker:${JULIA_VERSION}/g" ${DOCKER_FOLDER}/julia/deployment.yml

# Build a spark image for the kubernetes cluster.
${SPARK_FOLDER}/bin/docker-image-tool.sh -r ${ARTIFACT_REGISTRY} -t ${SPARK_VERSION} build

# Push the spark image to the repository.
${SPARK_FOLDER}/bin/docker-image-tool.sh -r ${ARTIFACT_REGISTRY} -t ${SPARK_VERSION} push
