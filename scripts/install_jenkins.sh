#!/bin/bash

# install_jenkins.sh
# Automatically installs Jenkins based on the detected Linux distribution
# Supports: Ubuntu, Debian, CentOS, RHEL, Amazon Linux, Rocky, AlmaLinux

set -e

echo -e "\n[+] Jenkins Installation Script (Auto-detect Linux OS)"
LOG_DIR="logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/install_jenkins_$(date +%F_%T).log"

# Ensure the script is run as root
if [[ "$EUID" -ne 0 ]]; then
  echo "[X] Please run this script as root or with sudo."
  exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS_ID=$ID
  OS_LIKE=$ID_LIKE
else
  echo "[X] Unable to detect operating system." | tee -a "$LOG_FILE"
  exit 1
fi

echo "[+] Detected OS: $OS_ID" | tee -a "$LOG_FILE"
echo "[DEBUG] OS_ID=$OS_ID, OS_LIKE=$OS_LIKE" | tee -a "$LOG_FILE"

install_jenkins_debian() {
  echo "[+] Installing Jenkins on Debian/Ubuntu..." | tee -a "$LOG_FILE"
  apt update -y
  apt install -y openjdk-11-jdk gnupg2 curl wget

  wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
  sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

  apt update -y
  apt install -y jenkins

  systemctl enable jenkins
  systemctl start jenkins
}

install_jenkins_rhel() {
  echo "[+] Installing Jenkins on RHEL/CentOS/Amazon Linux..." | tee -a "$LOG_FILE"

  # Special handling for Amazon Linux 2
  if grep -q "Amazon Linux" /etc/os-release; then
    echo "[+] Detected Amazon Linux - enabling java-openjdk11 via amazon-linux-extras" | tee -a "$LOG_FILE"
    amazon-linux-extras enable java-openjdk11
    yum clean metadata
  fi

  echo "[DEBUG] Installing dependencies..." | tee -a "$LOG_FILE"
  yum install -y java-11-openjdk wget curl

  echo "[DEBUG] Setting up Jenkins repo..." | tee -a "$LOG_FILE"
  wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

  echo "[DEBUG] Installing Jenkins package..." | tee -a "$LOG_FILE"
  yum install -y jenkins

  echo "[DEBUG] Enabling and starting Jenkins service..." | tee -a "$LOG_FILE"
  systemctl enable jenkins
  systemctl start jenkins
}

echo "[DEBUG] Starting installation for $OS_ID" | tee -a "$LOG_FILE"

# Choose installation path
case "$OS_ID" in
  ubuntu|debian)
    install_jenkins_debian
    ;;
  centos|rhel|amzn|rocky|almalinux)
    install_jenkins_rhel
    ;;
  *)
    echo "[X] Unsupported Linux distribution: $OS_ID" | tee -a "$LOG_FILE"
    exit 1
    ;;
esac

# Final Status
if systemctl is-active --quiet jenkins; then
  echo "[✓] Jenkins is installed and running at http://<your-server-ip>:8080" | tee -a "$LOG_FILE"
else
  echo "[X] Jenkins installation completed but the service is not running." | tee -a "$LOG_FILE"
fi

echo "[+] Installation complete. Logs saved to $LOG_FILE"
