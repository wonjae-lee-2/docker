#!/bin/bash

# Set environment variables.
SERVICE_ACCOUNT=service-account@glossy-essence-352111.iam.gserviceaccount.com
KEY_FILE=~/keys/key-gcloud.json
PROJECT_ID=glossy-essence-352111
CLUSTER_NAME=cluster-1
CLUSTER_ZONE=us-central1-a

# Authenticate with a service account.
gcloud auth activate-service-account $SERVICE_ACCOUNT --key-file=$KEY_FILE --project=$PROJECT_ID

# Configure kubectl command line access
gcloud container clusters get-credentials $CLUSTER_NAME --zone $CLUSTER_ZONE --project $PROJECT_ID
