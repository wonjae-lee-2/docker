#!/bin/bash

# Get user input for software versions.
echo
echo "Check the latest Python image. https://hub.docker.com/_/python"
read -p "Which version of Python would you like to build an image for? " INPUT_PYTHON_VERSION
echo
echo "Check the latest version of gcloud CLI. https://cloud.google.com/sdk/docs/install-sdk/"
read -p "Which version of gcloud CLI would you like to include in the Python, R and Julia images? " INPUT_GCLOUD_VERSION
echo
echo "Check the latest R image. https://hub.docker.com/r/rocker/rstudio"
read -p "Which version of R would you like to build an image for? " INPUT_R_VERSION
echo
echo "Check the latest version of Spark. https://spark.apache.org/ https://spark.apache.org/docs/latest/"
read -p "Which version of Spark would you like to include in the R image? " INPUT_SPARK_VERSION
read -p "Which version of Java compatible with Spark would you like to include in the R image? " INPUT_JAVA_VERSION
echo
echo "Check the latest Julia image. https://hub.docker.com/_/julia"
read -p "Which version of Julia would you like to build an image for? " INPUT_JULIA_VERSION
echo
echo "Check the latest PostgreSQL image. https://hub.docker.com/_/postgres"
read -p "Which version of PostgreSQL would you like to build an image for? " INPUT_POSTGRES_VERSION
read -p "What password would you like to use for PostgreSQL? " INPUT_POSTGRES_PASSWORD
echo
echo "Check the latest Trino image. https://hub.docker.com/r/trinodb/trino"
read -p "Which version of Trino would you like to build an image for? " INPUT_TRINO_VERSION

# Replace password and software versions in `template-wsl.yml` with environment variables to generate `compose.yml`.
sed -e "s/INPUT_PYTHON_VERSION/${INPUT_PYTHON_VERSION}/g" \
    -e "s/INPUT_GCLOUD_VERSION/${INPUT_GCLOUD_VERSION}/g" \
    -e "s/INPUT_R_VERSION/${INPUT_R_VERSION}/g" \
    -e "s/INPUT_SPARK_VERSION/${INPUT_SPARK_VERSION}/g" \
    -e "s/INPUT_JAVA_VERSION/${INPUT_JAVA_VERSION}/g" \
    -e "s/INPUT_JULIA_VERSION/${INPUT_JULIA_VERSION}/g" \
    template-wsl.yml > compose.yml

# Replace password and software versions in `template-ec2.yml` with environment variables to generate `compose-ec2.yml`.
sed -e "s/INPUT_POSTGRES_VERSION/${INPUT_POSTGRES_VERSION}/g" \
    -e "s/INPUT_POSTGRES_PASSWORD/${INPUT_POSTGRES_PASSWORD}/g" \
    -e "s/INPUT_TRINO_VERSION/${INPUT_TRINO_VERSION}/g" \
    template-aws.yml > compose-aws.yml

# Replace password in `template-values.yml` to generate `values.yml`.
sed -e "s/INPUT_POSTGRES_PASSWORD/${INPUT_POSTGRES_PASSWORD}/g" \
    trino/template-values.yml > trino/values.yml

# Copy the ssh public key to the julia and julia-worker sub-folder.
cp ~/.ssh/id_ed25519.pub ~/github/docker/julia
cp ~/.ssh/id_ed25519.pub ~/github/docker/julia-worker
