FROM kalilinux/kali-rolling:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:0

# Fix Kali GPG keys and repositories
RUN apt-get update --allow-insecure-repositories || true && \
    apt-get install -y --allow-unauthenticated kali-archive-keyring && \
    apt-get update

# Install only essential base packages needed for container functionality
RUN apt-get install -y \
    curl \
    wget \
    git \
    apt-utils \
    software-properties-common \
    zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Oh My Zsh (for better shell experience)
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true

# Set zsh as default shell
RUN chsh -s $(which zsh) || true

# Create work directory
RUN mkdir -p /work/{recon,enumeration,exploitation,post-exploitation,reports,tools,wordlists}

# Set working directory
WORKDIR /work

# Copy setup script (all tool installations moved here)
COPY setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

# Expose common pentesting ports
EXPOSE 8080 8000 4444 5432 9001 6633

# Set default command
CMD ["/bin/zsh"]
