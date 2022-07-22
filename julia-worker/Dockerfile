ARG JULIA_VERSION

FROM julia:${JULIA_VERSION}

ARG HOME=/root
ARG SSH_FOLDER=${HOME}/.ssh

WORKDIR ${HOME}

COPY id_ed25519.pub id_ed25519.pub
RUN apt update; \
    apt install --no-install-recommends -y openssh-server; \
    mkdir ${SSH_FOLDER}; \
    mv id_ed25519.pub ${SSH_FOLDER}; \
    cat ${SSH_FOLDER}/id_ed25519.pub >> ${SSH_FOLDER}/authorized_keys

COPY Project.toml Project.toml
COPY Manifest.toml Manifest.toml
COPY spec-file.txt spec-file.txt
RUN julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate(); import Conda; Conda.update()'; \
    ${HOME}/.julia/conda/3/bin/conda install -y --file spec-file.txt; \
    rm -rf /var/lib/apt/lists/*

EXPOSE 22

CMD ["sh", "-c", "service ssh start; tail -f /dev/null"]
