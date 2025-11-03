FROM mcr.microsoft.com/devcontainers/base:debian-12

ARG DOTNET_URL=https://dot.net/v1/dotnet-install.sh
ARG TERRAFORM_VERSION=1.9.6

WORKDIR /work/

# Install dependencies
RUN apt-get -y update && apt-get -y upgrade && \
    apt-get install --no-install-recommends -y \
        apt-utils \
        binutils-aarch64-linux-gnu \
        build-essential \
        curl \
        gcc \
        gcc-mingw-w64 \
        git \
        gnupg \
        libbz2-dev \
        libc-dev-arm64-cross \
        libffi-dev \
        libicu-dev \
        liblzma-dev \
        libsqlite3-dev \
        libssl-dev \
        make \
        protobuf-compiler \
        software-properties-common \
        tk-dev \
        wget \
        xz-utils \
        zlib1g-dev \
        file \
        unzip \
        xauth x11-apps \
        libicu72 \
        iputils-ping \
        vim \
        bind9-dnsutils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PowerShell
RUN wget -q https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install .NET SDKs as vscode user
USER vscode
WORKDIR /home/vscode/

RUN wget ${DOTNET_URL} -O dotnet-install.sh && \
    chmod +x ./dotnet-install.sh && \
    ./dotnet-install.sh --version 8.0.407 && \
    ./dotnet-install.sh --version 9.0.300

ENV PATH="/home/vscode/.dotnet/:/home/vscode/.dotnet/tools:${PATH}"
ENV DOTNET_ROOT="/home/vscode/.dotnet/"

# Install .NET global tools as vscode user
RUN dotnet tool install --global ilspycmd --version 9.1.0.7988 && \
    ./dotnet-install.sh --version 3.0.103 && \
    dotnet tool install --global dotnet-ildasm && \
    dotnet tool install --global dotnet-ilrepack && \
    dotnet tool install --global dotnet-outdated-tool && \
    dotnet tool install --global Obfuscar.GlobalTool

USER root
WORKDIR /work/

# Install Terraform (with signature verification)
RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig && \
    wget -qO- https://www.hashicorp.com/.well-known/pgp-key.txt | gpg --import && \
    gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    grep terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform_${TERRAFORM_VERSION}_SHA256SUMS | sha256sum -c && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform_${TERRAFORM_VERSION}_SHA256SUMS terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig

# Install Google Cloud SDK (gcloud)
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz && \
    tar -xzf google-cloud-cli-linux-x86_64.tar.gz && \
    mv google-cloud-sdk /usr/local/google-cloud-sdk && \
    ln -s /usr/local/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud && \
    rm google-cloud-cli-linux-x86_64.tar.gz

# Install GitHub CLI (gh)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python, pip, and set up a global virtualenv for the workspace in /work/venv
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv && \
    python3 -m venv /work/venv && \
    /work/venv/bin/pip install --upgrade pip && \
    /work/venv/bin/pip install pycryptodome && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PATH="/work/venv/bin:$PATH"

# SSH config symlink (for vscode user)
RUN mkdir -p /home/vscode/.ssh && \
    ln -sf /work/infra/.ssh/config /home/vscode/.ssh/config

CMD ["/bin/bash"]
