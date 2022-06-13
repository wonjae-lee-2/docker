# syntax=docker/dockerfile:1

FROM rocker/rstudio:4.2.0

ARG HOME=/home/rstudio
ARG SPARK_VERSION=3.2.1
ARG SPARK_FOLDER=/opt/spark-$SPARK_VERSION
ARG GCLOUD_VERSION=389.0.0
ARG GCLOUD_FOLDER=$HOME/gcloud-$GCLOUD_VERSION

WORKDIR $HOME

COPY requirements.r requirements.r
COPY gcloud-auth.sh gcloud-auth.sh

RUN apt update; \
    apt install -y --no-install-recommends \
        libglpk-dev \
        libpq-dev \
        libssl-dev  \
        libxml2-dev; \
    su - rstudio -c "Rscript requirements.r"; \
    apt install -y --no-install-recommends openjdk-11-jre; \
    wget https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.2.tgz; \
    mkdir $SPARK_FOLDER; \
    tar -x -f spark-$SPARK_VERSION-bin-hadoop3.2.tgz -C $SPARK_FOLDER --strip-components=1; \
    rm spark-$SPARK_VERSION-bin-hadoop3.2.tgz; \
    wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-$GCLOUD_VERSION-linux-x86_64.tar.gz; \
    mkdir $GCLOUD_FOLDER; \
    chown rstudio $GCLOUD_FOLDER; \
    su - rstudio -c "tar -x -f google-cloud-cli-$GCLOUD_VERSION-linux-x86_64.tar.gz -C $GCLOUD_FOLDER --strip-components=1"; \
    su - rstudio -c "$GCLOUD_FOLDER/install.sh --quiet --command-completion True --path-update True"; \
    su - rstudio -c "$GCLOUD_FOLDER/bin/gcloud components install kubectl --quiet"; \
    ln -fs $GCLOUD_FOLDER/bin/kubectl /usr/local/bin/kubectl; \
    rm google-cloud-cli-$GCLOUD_VERSION-linux-x86_64.tar.gz; \
    echo "bash ~/gcloud-auth.sh" >> /home/rstudio/.profile

EXPOSE 8787 4040

CMD ["/init"]
