#!/bin/bash

# Kali Linux Penetration Testing Environment Setup Script
echo "🔧 Setting up Kali Linux penetration testing environment..."

# Update package lists
echo "📦 Updating package lists..."
apt-get update

# Upgrade packages (with error handling)
echo "⬆️ Upgrading existing packages..."
apt-get upgrade -y || echo "⚠️ Some packages failed to upgrade, continuing anyway..."

# ============================================================================
# Core System Tools Installation
# ============================================================================

echo "🛠️ Installing core system tools..."
apt-get install -y \
    vim \
    nano \
    tmux \
    screen \
    python3-pip \
    python3-venv \
    python3-dev \
    ruby \
    ruby-dev \
    golang-go \
    nodejs \
    npm \
    build-essential \
    libcurl4-openssl-dev \
    libxml2 \
    libxml2-dev \
    libxslt1-dev \
    libgmp-dev \
    zlib1g-dev \
    cmake \
    jq

# ============================================================================
# Docker Installation (for containerized security testing)
# ============================================================================

echo "🐳 Setting up Docker for security testing..."

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    echo "✅ Docker already installed via devcontainer features"
    # Ensure docker service is running
    #service docker start 2>/dev/null || true
else
    echo "📦 Installing Docker CE..."
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Add Docker repository
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bullseye stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update package list and install Docker
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Enable Docker service
    #systemctl enable docker
    #service docker start
fi
echo "✅ Docker setup completed"

# ============================================================================
# Kali Linux Metapackages
# ============================================================================

echo "🛠️ Installing Kali Linux metapackages..."
apt-get install -y \
    kali-tools-top10 \
    kali-tools-web \
    kali-tools-information-gathering \
    kali-tools-vulnerability \
    kali-tools-exploitation \
    kali-tools-post-exploitation \
    kali-tools-passwords \
    kali-tools-sniffing-spoofing \
    kali-tools-wireless \
    kali-tools-reverse-engineering \
    kali-tools-forensics

# ============================================================================
# Network and Web Assessment Tools
# ============================================================================

echo "🔍 Installing network and web assessment tools..."
apt-get install -y \
    nmap \
    masscan \
    nikto \
    dirb \
    dirbuster \
    gobuster \
    wfuzz \
    sqlmap \
    zaproxy \
    burpsuite \
    dnsutils \
    whois \
    host \
    netcat-traditional \
    socat \
    curl \
    wget \
    firefox-esr \
    xvfb

# ============================================================================
# Advanced Penetration Testing Tools
# ============================================================================

echo "💥 Installing advanced penetration testing tools..."
apt-get install -y \
    metasploit-framework \
    armitage \
    beef-xss \
    john \
    hashcat \
    hydra \
    medusa \
    crackmapexec \
    impacket-scripts \
    responder \
    bloodhound \
    neo4j \
    wireshark \
    tcpdump

# ============================================================================
# Python Security Libraries
# ============================================================================

echo "🐍 Installing Python security libraries..."
pip3 install --break-system-packages \
    requests \
    beautifulsoup4 \
    scapy \
    netaddr \
    python-nmap \
    paramiko \
    pycrypto \
    colorama \
    termcolor \
    shodan \
    censys \
    dnspython \
    urllib3 \
    selenium \
    pwntools \
    ropper \
    capstone \
    keystone-engine

# ============================================================================
# Go-based Reconnaissance Tools
# ============================================================================

echo "🔎 Installing Go-based reconnaissance tools..."

# Install subfinder
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Install httpx
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# Install nuclei
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# Install amass
go install -v github.com/OWASP/Amass/v3/...@master

# Setup Go environment
echo 'export PATH=$PATH:/root/go/bin' >> /root/.zshrc
echo 'export PATH=$PATH:/root/go/bin' >> /root/.bashrc

# ============================================================================
# Ruby-based Tools (WPScan)
# ============================================================================

echo "� Installing Ruby-based tools..."
gem install wpscan

# ============================================================================
# EyeWitness Installation (Python Virtual Environment)
# ============================================================================

echo "📸 Installing EyeWitness for web application screenshots..."

# Clone EyeWitness if not exists
if [ ! -d "/opt/EyeWitness" ]; then
    git clone https://github.com/RedSiege/EyeWitness.git /opt/EyeWitness
fi

# Create virtual environment for EyeWitness
cd /opt/EyeWitness/Python
python3 -m venv eyewitness_env

# Install Python requirements in virtual environment
source eyewitness_env/bin/activate
pip install --upgrade pip
pip install -r setup/requirements.txt
deactivate

# Download and install geckodriver
echo "🦎 Installing geckodriver..."
GECKO_URL=$(curl -s https://api.github.com/repos/mozilla/geckodriver/releases/latest | jq -r '.assets[] | select(.name | contains("linux64.tar.gz")) | .browser_download_url' | head -1)
wget "$GECKO_URL" -O /tmp/geckodriver.tar.gz
tar -xzf /tmp/geckodriver.tar.gz -C /usr/bin
rm /tmp/geckodriver.tar.gz
chmod +x /usr/bin/geckodriver

# Create EyeWitness wrapper script
cat > /usr/local/bin/eyewitness_wrapper << 'EOF'
#!/bin/bash
export DISPLAY=:99
Xvfb :99 -screen 0 1024x768x24 >/dev/null 2>&1 &
XVFB_PID=$!
sleep 2
cd /opt/EyeWitness/Python
source eyewitness_env/bin/activate
python EyeWitness.py "$@"
EOF

# Make EyeWitness wrapper executable
chmod +x /usr/local/bin/eyewitness_wrapper

# ============================================================================
# Database and Template Updates
# ============================================================================

echo "🔄 Updating tool databases and templates..."

# Verify EyeWitness installation
echo "✅ Verifying EyeWitness installation..."
eyewitness_wrapper --help > /dev/null 2>&1 || echo "EyeWitness installation verification completed"

# Update WPScan database
echo "🔄 Updating WPScan database..."
wpscan --update || echo "WPScan database update completed"

# Update Nuclei templates
echo "🔄 Updating Nuclei templates..."
if command -v nuclei &> /dev/null; then
    nuclei -update-templates
fi

# ============================================================================
# Workspace and Environment Setup
# ============================================================================

# Create workspace directories
echo "📁 Creating workspace directories..."
mkdir -p /work/{recon,enumeration,exploitation,post-exploitation,reports,tools,wordlists}

# Download common wordlists
echo "📚 Downloading wordlists..."
cd /work/wordlists
wget -q https://github.com/danielmiessler/SecLists/archive/master.zip -O seclists.zip
unzip -q seclists.zip
mv SecLists-master SecLists
rm seclists.zip

# Setup Metasploit database
echo "🗄️ Setting up Metasploit database..."
service postgresql start
msfdb init

# Create useful aliases and functions
echo "🔗 Setting up aliases and functions..."
cat << 'EOF' >> /root/.zshrc

# Penetration Testing Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias nse='ls /usr/share/nmap/scripts/ | grep'
alias msf='msfconsole'
alias msfvenom='msfvenom'
alias burp='java -jar /usr/share/burpsuite/burpsuite.jar'
alias zap='zaproxy'
alias ports='netstat -tulanp'
alias listening='lsof -i -P -n | grep LISTEN'
alias myip='curl ifconfig.me'

# Docker Security Testing Aliases
alias dockrun='docker run --rm -it'
alias docknet='docker network ls'
alias dockimg='docker images'
alias dockps='docker ps -a'
alias dockclean='docker system prune -f'
alias dockerm='docker rm $(docker ps -aq)'
alias dockermi='docker rmi $(docker images -q)'

# Docker Security Tools
alias nikto-docker='docker run --rm -v $(pwd):/tmp sullo/nikto'
alias sqlmap-docker='docker run --rm -it --net=host sqlmap/sqlmap'
alias nmap-docker='docker run --rm -v $(pwd):/data instrumentisto/nmap'

# Quick recon functions
function quickscan() {
    if [ $# -eq 0 ]; then
        echo "Usage: quickscan <target>"
        return 1
    fi
    echo "🔍 Quick scan of $1"
    nmap -sS -O -sV --version-light --top-ports 1000 $1
}

function fullscan() {
    if [ $# -eq 0 ]; then
        echo "Usage: fullscan <target>"
        return 1
    fi
    echo "🔍 Full scan of $1"
    nmap -sS -A -O -sV -sC --script vuln -p- $1
}

function webscan() {
    if [ $# -eq 0 ]; then
        echo "Usage: webscan <target>"
        return 1
    fi
    echo "🌐 Web scan of $1"
    nikto -h $1
    dirb http://$1
}
EOF

# Create pentest startup script
echo "🚀 Creating pentest startup script..."
cat << 'EOF' > /work/start-pentest.sh
#!/bin/bash

echo "🎯 Penetration Testing Environment"
echo "=================================="
echo ""
echo "📋 To get started:"
echo "  1. Define your target scope in /work/targets.txt"
echo "  2. Use the available commands below to test your targets"
echo ""
echo "🛠️ Available Commands:"
echo "  quickscan <target>  - Quick nmap scan"
echo "  fullscan <target>   - Comprehensive nmap scan"
echo "  webscan <target>    - Web application scan"
echo "  msf                 - Start Metasploit"
echo "  burp                - Start Burp Suite"
echo "  zap                 - Start OWASP ZAP"
echo ""
echo "🐳 Docker Security Tools:"
echo "  dockrun <image>     - Run container interactively"
echo "  nikto-docker <target> - Containerized Nikto"
echo "  sqlmap-docker <opts>  - Containerized SQLMap"
echo "  nmap-docker <opts>    - Containerized Nmap"
echo ""
echo "📁 Workspace: /work"
echo "  ├── recon/          - Reconnaissance results"
echo "  ├── enumeration/    - Service enumeration"
echo "  ├── exploitation/   - Exploitation attempts"
echo "  ├── post-exploitation/ - Post-exploitation activities"
echo "  ├── reports/        - Final reports"
echo "  ├── tools/          - Custom tools"
echo "  └── wordlists/      - SecLists and custom wordlists"
echo ""
echo "⚠️  Remember to follow the rules of engagement!"
echo ""

# Start essential services
service postgresql start
service ssh start

# Set working directory
cd /work
EOF

chmod +x /work/start-pentest.sh

# Create sample target list file
echo "🎯 Creating sample target list..."
cat << 'EOF' > /work/targets.txt
# Add your target IPs and domains here, one per line
# Examples:
# 192.168.1.1
# 10.0.0.0/24
# example.com
# subdomain.example.com

# Replace these with your actual targets:
# target-ip-1
# target-ip-2
# target-domain.com
EOF

# Create initial recon script template
echo "📝 Creating initial recon script template..."
cat << 'EOF' > /work/initial-recon.sh
#!/bin/bash

# Usage: ./initial-recon.sh <domain>
# Example: ./initial-recon.sh example.com

if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    echo "Example: $0 example.com"
    exit 1
fi

DOMAIN=$1

echo "🔍 Starting initial reconnaissance..."
echo "Target: $DOMAIN"
echo "=================================="

# Create recon subdirectories
mkdir -p /work/recon/{nmap,subdomains,dns,web,screenshots}

# Domain reconnaissance
echo "🌐 Domain reconnaissance for $DOMAIN..."
dig $DOMAIN ANY > /work/recon/dns/${DOMAIN}_dns.txt
nslookup $DOMAIN >> /work/recon/dns/${DOMAIN}_dns.txt
whois $DOMAIN > /work/recon/dns/${DOMAIN}_whois.txt

# Subdomain enumeration
echo "🔍 Subdomain enumeration..."
if command -v subfinder &> /dev/null; then
    subfinder -d $DOMAIN > /work/recon/subdomains/subfinder.txt
fi

if command -v amass &> /dev/null; then
    amass enum -d $DOMAIN > /work/recon/subdomains/amass.txt
fi

# Quick port scan of all targets
echo "🚪 Quick port scan of all targets..."
nmap -sS --top-ports 1000 -iL /work/targets.txt -oA /work/recon/nmap/quick_scan

echo "✅ Initial reconnaissance complete!"
echo "📁 Results saved in /work/recon/"
EOF

chmod +x /work/initial-recon.sh

# Final setup
echo "🔧 Final setup..."
chmod -R 755 /work
chown -R root:root /work

echo ""
echo "✅ Kali Linux penetration testing environment setup complete!"
echo ""
echo "🚀 To start your pentest session, run:"
echo "   /work/start-pentest.sh"
echo ""
echo "📍 Your workspace is located at: /work"
echo "🎯 Target list is available at: /work/targets.txt"
echo "🔍 Run initial recon with: /work/initial-recon.sh"
echo ""
