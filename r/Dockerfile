# syntax=docker/dockerfile:1

FROM rocker/rstudio:4.2.0

ARG HOME=/home/rstudio
ARG JAVA_VERSION=11
ARG SPARK_VERSION=3.3.0
ARG SPARK_FOLDER=/opt/spark/${SPARK_VERSION}
ARG GCLOUD_VERSION=390.0.0
ARG GCLOUD_FOLDER=${HOME}/gcloud

WORKDIR ${HOME}

RUN apt update; \
    apt install -y --no-install-recommends openjdk-${JAVA_VERSION}-jre; \
    wget https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz; \
    mkdir -p ${SPARK_FOLDER}; \
    tar -x -f spark-${SPARK_VERSION}-bin-hadoop3.tgz -C ${SPARK_FOLDER} --strip-components=1; \
    rm spark-${SPARK_VERSION}-bin-hadoop3.tgz

RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz; \
    mkdir ${GCLOUD_FOLDER}; \
    chown rstudio ${GCLOUD_FOLDER}; \
    su - rstudio -c "tar -x -f google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz -C ${GCLOUD_FOLDER} --strip-components=1"; \
    su - rstudio -c "${GCLOUD_FOLDER}/install.sh --quiet --command-completion True --path-update True"; \
    su - rstudio -c "${GCLOUD_FOLDER}/bin/gcloud components install kubectl --quiet"; \
    ln -fs ${GCLOUD_FOLDER}/bin/kubectl /usr/local/bin/kubectl; \
    rm google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz; \
    echo ${HOME}/keys/gcloud-auth.sh >> ${HOME}/.profile

COPY renv.r renv.r
RUN su - rstudio -c "Rscript renv.r"

COPY .Rprofile .Rprofile
COPY renv.lock renv.lock
COPY renv/activate.R renv/activate.R
COPY renv/settings.dcf renv/settings.dcf
RUN apt install -y --no-install-recommends \
        libcurl4-openssl-dev \
        libssl-dev \
        libpq-dev \
        libxml2-dev; \
    chown -R rstudio ${HOME}/renv; \
    su - rstudio -c "R -e 'renv::restore()'"

EXPOSE 8787

CMD ["/init"]
