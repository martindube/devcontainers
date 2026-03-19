# DevContainers Collection

This repository contains a collection of VS Code Development Containers (devcontainers) tailored for cybersecurity and red team operations. Each devcontainer provides a pre-configured development environment with all necessary tools and dependencies.

## 📋 Quick Overview

| Container | Base Image | Primary Use Case | Key Tools | Capabilities |
|-----------|------------|------------------|-----------|--------------|
| 🏛️ **[Athena](#️-athena)** | `ubuntu:24.04` | Mythic C2 Agent Development | .NET SDK, Python 3.12, donut, Obfuscar | Cross-compilation (ARM64/Windows) |
| 🐉 **[Kali](#-kali)** | `kalilinux/kali-rolling` | Penetration Testing | nmap, metasploit, burpsuite, nuclei | `NET_ADMIN`, `NET_RAW`, `SYS_ADMIN` capabilities |
| 🎯 **[RedTeam](#-redteam)** | `mcr.microsoft.com/devcontainers/base:debian-12` | Red Team Operations | .NET tools, Terraform, PowerShell | Cloud infrastructure, X11 forwarding |

## Available Containers

### 🏛️ Athena

**Path:** `athena/`
**Base Image:** `ubuntu:24.04`

Development environment for the Athena agent within the Mythic C2 framework. This container includes:

- **Language Support:**
  - Python 3.12 with development headers (`python3.12-dev`)
  - .NET SDK 8.0.403 and 9.0.300 with cross-platform support
  - Go build tools and cross-compilation support
  
- **Security/C2 Development Tools:**
  - `pycryptodome` - Advanced cryptographic operations
  - `mythic-container` - Mythic C2 framework integration
  - `pefile` - PE file analysis and manipulation
  - `donut` (v2.0.0) - Shellcode generation with ARM64 support
  - `Obfuscar.GlobalTool` - .NET obfuscation capabilities
  
- **Cross-compilation Support:**
  - `gcc-mingw-w64` - Windows cross-compilation
  - `binutils-aarch64-linux-gnu` - ARM64 toolchain
  - `libc-dev-arm64-cross` - ARM64 development libraries
  
- **Build Tools:**
  - `protobuf-compiler` - Protocol buffer compilation
  - Complete build toolchain (`build-essential`, `make`, `gcc`)

**Use Case:** Developing, testing, and customizing Athena payloads for the Mythic Command & Control framework with multi-architecture support.

### 🐉 Kali

**Path:** `kali/`
**Base Image:** `kalilinux/kali-rolling:latest`

Comprehensive penetration testing environment with Kali Linux metapackages and advanced security tools. This container provides:

- **Kali Metapackages:**
  - `kali-tools-top10` - Essential penetration testing tools
  - `kali-tools-web` - Web application security testing
  - `kali-tools-information-gathering` - Reconnaissance tools
  - `kali-tools-vulnerability` - Vulnerability assessment
  - `kali-tools-exploitation` - Exploitation frameworks
  - `kali-tools-post-exploitation` - Post-exploitation utilities
  - `kali-tools-passwords` - Password cracking tools
  - `kali-tools-wireless` - Wireless security testing

- **Network Assessment Tools:**
  - `nmap`, `masscan` - Network discovery and port scanning
  - `nikto`, `gobuster`, `dirbuster`, `wfuzz` - Web enumeration
  - `sqlmap` - Automated SQL injection testing
  - `burpsuite`, `zaproxy` - Web application security proxies
  - `wireshark`, `tcpdump` - Network traffic analysis

- **Advanced Frameworks:**
  - `metasploit-framework` - Exploitation framework
  - `impacket-scripts` - Windows protocol implementations
  - `crackmapexec` - Active Directory assessment
  - `bloodhound` + `neo4j` - Active Directory attack path analysis
  - `beef-xss` - Browser exploitation framework

- **Password/Hash Cracking:**
  - `john`, `hashcat` - Password cracking suites
  - `hydra`, `medusa` - Network service brute forcing

- **Go-based Reconnaissance:**
  - `subfinder`, `amass` - Subdomain enumeration
  - `httpx` - HTTP probing and analysis
  - `nuclei` - Vulnerability scanner with templates

- **Python Security Libraries:**
  - `scapy`, `python-nmap`, `pwntools` - Security automation
  - `selenium` - Web automation for testing
  - `paramiko` - SSH implementation
  - `shodan`, `censys` - Internet-wide scanning APIs

**Container Capabilities:** Runs with `NET_ADMIN`, `NET_RAW`, and `SYS_ADMIN` capabilities for comprehensive network testing.

**Forwarded Ports:**
  - `8080` - Burp Suite proxy
  - `8000` - Simple HTTP server
  - `4444` - Metasploit default listener
  - `5432` - PostgreSQL (for Metasploit)
  - `9001` - Common reverse shell port
  - `6633` - OWASP ZAP proxy

**VS Code Extensions:** Python, Debugpy, Hex Editor, PowerShell, YAML, Jupyter, and JSON support.

**Use Case:** Comprehensive penetration testing, vulnerability assessments, and security research in an isolated environment with full Kali Linux toolset.

### 🎯 RedTeam

**Path:** `redteam/`
**Base Image:** `mcr.microsoft.com/devcontainers/base:debian-12`

Advanced red team operations environment with cloud infrastructure and development tools. This container includes:

- **Development Frameworks:**
  - .NET SDK 8.0.407, 9.0.300, and 3.0.103 - Multi-version .NET development
  - PowerShell Core - Cross-platform PowerShell automation
  - Python 3 with virtual environment (`/work/venv`) - Isolated Python development
  - Cross-compilation toolchain (`gcc-mingw-w64`, ARM64 support)

- **.NET Reverse Engineering Tools:**
  - `ilspycmd` (v9.1.0.7988) - Command-line IL decompiler
  - `dotnet-ildasm` - IL disassembler
  - `dotnet-ilrepack` - Assembly merging utility
  - `dotnet-outdated-tool` - Dependency analysis
  - `Obfuscar.GlobalTool` - Code obfuscation

- **Infrastructure & Cloud Tools:**
  - `terraform` (v1.9.6) - Infrastructure as Code with signature verification
  - `gcloud` - Google Cloud Platform CLI
  - `gh` - GitHub CLI for repository operations
  - SSH key management with workspace integration

- **Security Libraries:**
  - `pycryptodome` - Advanced cryptographic operations
  - Network utilities (`iputils-ping`, `bind9-dnsutils`)
  - File analysis tools (`file`, `unzip`)

- **Container Capabilities:**
  - X11 forwarding support (`DISPLAY` environment)
  - Docker socket mounting for containerized operations
  - SSH key mounting from host system
  - Workspace persistence at `/work`

**VS Code Extensions:** Comprehensive suite including C# DevKit, PowerShell, Azure CLI, Docker, Terraform, and Markdown tools.

**Use Case:** Advanced red team exercises, cloud infrastructure assessment, .NET application security testing, and adversarial simulation with development capabilities.

## 🚀 Getting Started

### Prerequisites

- [VS Code](https://code.visualstudio.com/)
- [Docker](https://www.docker.com/get-started)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Usage

1. Clone this repository:

   ```bash
   git clone <repository-url>
   cd devcontainers
   ```

2. Open the desired container folder in VS Code:

   ```bash
   code athena/    # For Athena development
   code kali/      # For penetration testing
   code redteam/   # For red team operations
   ```

3. When prompted, click "Reopen in Container" or use the command palette:
   - Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
   - Type "Dev Containers: Reopen in Container"
   - Select the command

4. VS Code will build and start the devcontainer with all pre-configured tools and dependencies.

## 🔧 Container Structure

Each container follows the standard devcontainer structure:

```text
container-name/
├── .devcontainer/
│   ├── devcontainer.json    # Container configuration
│   ├── Dockerfile           # Container image definition
│   └── docker-compose.yml   # Multi-service setup (if needed)
└── [additional files]       # Container-specific resources
```

## ⚠️ Important

Please review the devcontainer configurations before use to ensure they meet your security and environment requirements.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests to improve these devcontainer configurations.
