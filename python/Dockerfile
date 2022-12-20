ARG PYTHON_VERSION

FROM python:${PYTHON_VERSION}

ARG GCLOUD_VERSION
ARG DOTNET_VERSION

ARG HOME=/root
ARG GCLOUD_FOLDER=${HOME}/gcloud

WORKDIR ${HOME}

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -U pip setuptools wheel; \
    pip install --no-cache-dir -U -r requirements.txt; \
    playwright install chromium; \
    playwright install-deps chromium

RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz; \
    mkdir ${GCLOUD_FOLDER}; \
    tar -x -f google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz -C ${GCLOUD_FOLDER} --strip-components=1; \
    ${GCLOUD_FOLDER}/install.sh --quiet --command-completion True --path-update True; \
    ${GCLOUD_FOLDER}/bin/gcloud components install kubectl --quiet; \
    ln -fs ${GCLOUD_FOLDER}/bin/gcloud /usr/local/bin/gcloud; \
    ln -fs ${GCLOUD_FOLDER}/bin/kubectl /usr/local/bin/kubectl; \
    rm google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz; \
    echo "bash ${HOME}/secret/gcloud-auth.sh" >> ${HOME}/.profile

COPY runtimeconfig.json runtimeconfig.json
RUN wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb; \
    dpkg -i packages-microsoft-prod.deb; \
    rm packages-microsoft-prod.deb; \
    apt update; \
    apt install --no-install-recommends -y apt-transport-https; \
    apt update; \
    apt install --no-install-recommends -y dotnet-sdk-${DOTNET_VERSION}

RUN apt install --no-install-recommends -y \
        ca-certificates \
        curl \
        apt-transport-https \
        lsb-release \
        gnupg; \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null; \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list; \
    apt update; \
    apt install azure-cli; \
    echo 'AZ_ACCOUNT=$(az account list); if [ ${#AZ_ACCOUNT} -eq 2 ]; then az login --allow-no-subscriptions --use-device-code; fi' >> ${HOME}/.profile; \
    rm -rf /var/lib/apt/lists/*

EXPOSE 8888

CMD ["jupyter", "lab", "--allow-root", "--no-browser", "--ip=0.0.0.0", "--port=8888"]
