#!/bin/bash

# Get user input for the Spark version.
echo
read -p "Which version of Spark would you like to build an image for? " SPARK_VERSION

# Set environment variables.
INSTALL_FOLDER=/opt/spark/${SPARK_VERSION}
ARTIFACT_REGISTRY=us-central1-docker.pkg.dev/project-lee-1/docker

# Build a docker image for the kubernetes cluster.
${INSTALL_FOLDER}/bin/docker-image-tool.sh -r ${ARTIFACT_REGISTRY} -t ${SPARK_VERSION} build

# Push the docker image to the repository.
${INSTALL_FOLDER}/bin/docker-image-tool.sh -r ${ARTIFACT_REGISTRY} -t ${SPARK_VERSION} push
