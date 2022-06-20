#!/bin/bash

JULIA_VERSION=1.7.3
PROJECT_ID=project-lee-1
ARTIFACT_REGISTRY=us-central1-docker.pkg.dev/$PROJECT_ID/docker

docker tag docker/julia:$JULIA_VERSION $ARTIFACT_REGISTRY/julia:$JULIA_VERSION

docker push $ARTIFACT_REGISTRY/julia:$JULIA_VERSION

docker rmi $ARTIFACT_REGISTRY/julia:$JULIA_VERSION
