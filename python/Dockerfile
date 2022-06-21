# syntax=docker/dockerfile:1

FROM python:3.10.5

ARG HOME=/home/python
ARG GCLOUD_VERSION=390.0.0
ARG GCLOUD_FOLDER=${HOME}/gcloud

RUN useradd -m python

WORKDIR ${HOME}

COPY requirements.txt requirements.txt
RUN pip install -U pip setuptools wheel; \
    pip install -U -r requirements.txt

RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz; \
    mkdir ${GCLOUD_FOLDER}; \
    chown python ${GCLOUD_FOLDER}; \
    su - python -c "tar -x -f google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz -C ${GCLOUD_FOLDER} --strip-components=1"; \
    su - python -c "${GCLOUD_FOLDER}/install.sh --quiet --command-completion True --path-update True"; \
    su - python -c "${GCLOUD_FOLDER}/bin/gcloud components install kubectl --quiet"; \
    ln -fs ${GCLOUD_FOLDER}/bin/gcloud /usr/local/bin/gcloud; \
    ln -fs ${GCLOUD_FOLDER}/bin/kubectl /usr/local/bin/kubectl; \
    rm google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz; \
    echo ${HOME}/keys/gcloud-auth.sh >> $HOME/.profile

USER python

EXPOSE 8888

CMD ["jupyter", "lab", "--allow-root", "--no-browser", "--ip=0.0.0.0", "--port=8888"]
