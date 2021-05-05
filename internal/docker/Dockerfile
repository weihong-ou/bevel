# USAGE: 
# docker build . -t baf-build
# docker run -v $(pwd):/home/blockchain-automation-framework/ baf-build

FROM ubuntu:18.04

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        curl \
        unzip \
        build-essential \
        default-jre \
	    openssh-client \
        gcc \
        git \
        libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev \
        jq \
        python \
        python3-dev \
        python3-pip && \
        pip3 install --no-cache --upgrade pip setuptools wheel && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install ansible && \
    pip3 install jmespath && \
    pip3 install openshift==0.10.1

RUN rm /etc/apt/apt.conf.d/docker-clean
RUN mkdir /etc/ansible/
RUN /bin/echo -e "[ansible_provisioners:children]\nlocal\n[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# The mounted repo should contain a build folder with the following files
# 1) K8s config file as config
# 2) Network specific configuration file as network.yaml
# 3) Private key file which has write-access to the git repo

#path to mount the repo
VOLUME /home/blockchain-automation-framework/

## Customizations
# Create non-privileged user
RUN groupadd --gid 10000 baf \
    && useradd --uid 10001 --gid baf --shell /bin/bash --create-home bafusr

RUN mkdir -p /home/bafusr/bin

# Install the dependencies, helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/v3.4.2/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && cp /usr/local/bin/helm /home/bafusr/bin/ \
    && chmod +x /home/bafusr/bin/helm

# Install kubectl
RUN curl -LO https://dl.k8s.io/release/v1.18.14/bin/linux/amd64/kubectl \
    && mv kubectl /home/bafusr/bin/kubectl \
    && chmod +x /home/bafusr/bin/kubectl

# Install vault
RUN VAULT_VERSION=1.5.3 \
    && curl -sO https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip \
    && unzip  vault_${VAULT_VERSION}_linux_amd64.zip \
    && mv vault /home/bafusr/bin/vault \
    && chmod +x /home/bafusr/bin/vault

ENV PATH=/home/bafusr/bin:/home/bafusr/.local/bin:$PATH

# To load the blockchain-automation-framework source code
WORKDIR /home/blockchain-automation-framework

CMD ["/home/run.sh"]
