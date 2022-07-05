# syntax=docker/dockerfile:1

ARG JULIA_VERSION

FROM julia:${JULIA_VERSION}

ARG GCLOUD_VERSION

ARG HOME=/root
ARG GCLOUD_FOLDER=${HOME}/gcloud
ARG SSH_FOLDER=${HOME}/.ssh

WORKDIR ${HOME}

COPY cluster.sh cluster.sh
COPY deployment.yml deployment.yml
COPY id_ed25519.pub id_ed25519.pub
RUN apt update; \
    apt install -y openssh-server; \
    mkdir ${SSH_FOLDER}; \
    mv id_ed25519.pub ${SSH_FOLDER}; \
    cat ${SSH_FOLDER}/id_ed25519.pub >> ${SSH_FOLDER}/authorized_keys

RUN apt install -y \
        wget \
        python3; \
    wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz; \
    mkdir ${GCLOUD_FOLDER}; \
    tar -x -f google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz -C ${GCLOUD_FOLDER} --strip-components=1; \
    ${GCLOUD_FOLDER}/install.sh --quiet --command-completion True --path-update True; \
    ${GCLOUD_FOLDER}/bin/gcloud components install kubectl --quiet; \
    ln -fs ${GCLOUD_FOLDER}/bin/gcloud /usr/local/bin/gcloud; \
    ln -fs ${GCLOUD_FOLDER}/bin/kubectl /usr/local/bin/kubectl; \
    rm google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz; \
    echo ${HOME}/keys/gcloud-auth.sh >> $HOME/.profile

COPY Project.toml Project.toml
COPY Manifest.toml Manifest.toml
COPY spec-file.txt spec-file.txt
RUN julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate(); import Conda; Conda.update()'; \
    ${HOME}/.julia/conda/3/bin/conda install -y --file spec-file.txt

COPY pluto.sh pluto.sh

EXPOSE 1234

CMD ["/root/.julia/conda/3/bin/jupyter", "lab", "--allow-root", "--no-browser", "--ip=0.0.0.0", "--port=1234"]
