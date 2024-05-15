ARG __base_image=ubuntu:22.04
FROM ${__base_image}

ARG __WORKSPACE_FOLDER=/workspace
ARG __HCLEDIT_TGZ_FILENAME=hcledit_0.2.11_linux_amd64.tar.gz

RUN apt-get -qy update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        awscli \
        curl \
        git \
        python3 \
        python3-pip \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && pip install git-remote-codecommit \
    && wget https://github.com/minamijoyo/hcledit/releases/download/v0.2.11/${__HCLEDIT_TGZ_FILENAME} \
    && tar -zxvf ${__HCLEDIT_TGZ_FILENAME} \
    && mv hcledit /usr/local/bin \
    && curl https://get.trunk.io -fsSL | bash

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
