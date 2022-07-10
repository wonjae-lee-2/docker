ARG PYTHON_VERSION

FROM python:${PYTHON_VERSION}

ARG GCLOUD_VERSION

ARG HOME=/root
ARG GCLOUD_FOLDER=${HOME}/gcloud

WORKDIR ${HOME}

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -U pip setuptools wheel; \
    pip install --no-cache-dir -U -r requirements.txt

RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz; \
    mkdir ${GCLOUD_FOLDER}; \
    tar -x -f google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz -C ${GCLOUD_FOLDER} --strip-components=1; \
    ${GCLOUD_FOLDER}/install.sh --quiet --command-completion True --path-update True; \
    ${GCLOUD_FOLDER}/bin/gcloud components install kubectl --quiet; \
    ln -fs ${GCLOUD_FOLDER}/bin/gcloud /usr/local/bin/gcloud; \
    ln -fs ${GCLOUD_FOLDER}/bin/kubectl /usr/local/bin/kubectl; \
    rm google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz; \
    echo "bash ${HOME}/keys/gcloud-auth.sh" >> $HOME/.profile

EXPOSE 8888

CMD ["jupyter", "lab", "--allow-root", "--no-browser", "--ip=0.0.0.0", "--port=8888"]
