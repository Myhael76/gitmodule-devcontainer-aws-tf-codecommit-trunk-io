ARG __base_image=ubuntu:22.04
FROM ${__base_image}

ARG __WORKSPACE_FOLDER=/workspace
ARG __HCLEDIT_TGZ_FILENAME=hcledit_0.2.11_linux_amd64.tar.gz

RUN apt-get -qy update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -qy install --no-install-recommends \
        awscli \
        curl \
        git \
        gpg \
        lsb-release \
        python3 \
        python3-pip \
        wget \
    && pip install git-remote-codecommit \
    && wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get -qy update && apt-get -qy install terraform \
    && wget https://github.com/minamijoyo/hcledit/releases/download/v0.2.11/${__HCLEDIT_TGZ_FILENAME} \
    && tar -zxvf ${__HCLEDIT_TGZ_FILENAME} \
    && mv hcledit /usr/local/bin \
    && curl https://get.trunk.io -fsSL | bash \
    && rm -rf /var/lib/apt/lists/*

ARG __GID=1000
ARG __GNAME=vscode
ARG __UID=1000
ARG __UNAME=vscode
ARG __UHOME=/home/${__UNAME}

RUN groupadd -g ${__GID} ${__GNAME} \
    && useradd -rm -d ${__UHOME} -s /bin/bash -g ${__GID} -u ${__UID} ${__UNAME} \
    && mkdir -p ${__WORKSPACE_FOLDER} \
    && chown ${__UNAME}:${__GNAME} ${__WORKSPACE_FOLDER} \
    && git config --global --add safe.directory ${__WORKSPACE_FOLDER} \
    && chown -R ${__UNAME}:${__GNAME} /usr/local/bin

# Note last command to force trunk to work, otherwise it goes in permission denied error

USER ${__UNAME}
