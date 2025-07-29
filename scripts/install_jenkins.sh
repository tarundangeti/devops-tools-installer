#!/bin/bash
#
# install_jenkins_latest.sh
# Installs the latest Jenkins on most Linux systems

set -e

LOG_DIR="logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/install_jenkins_$(date +%F_%T).log"

echo -e "\n[+] Jenkins Universal Installation Script"
echo "[i] Logging to $LOG_FILE"

# Ensure the script is run as root
if [[ "$EUID" -ne 0 ]]; then
  echo "[X] Please run this script as root or with sudo."
  exit 1
fi

# Detect major OS family
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS_ID=$(echo "$ID" | tr '[:upper:]' '[:lower:]')
else
  echo "[X] Unable to detect operating system." | tee -a "$LOG_FILE"
  exit 1
fi

echo "[+] Detected OS: $OS_ID" | tee -a "$LOG_FILE"

install_debian_like() {
  echo "[+] Installing Java 11 and dependencies..." | tee -a "$LOG_FILE"
  apt-get update -y
  apt-get install -y openjdk-11-jdk gnupg curl wget

  echo "[+] Adding Jenkins repository..." | tee -a "$LOG_FILE"
  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

  apt-get update -y
  echo "[+] Installing Jenkins (latest)..." | tee -a "$LOG_FILE"
  apt-get install -y jenkins

  systemctl enable jenkins
  systemctl restart jenkins
}

install_redhat_like() {
  PKGM=""
  if command -v dnf >/dev/null 2>&1; then
    PKGM=dnf
  else
    PKGM=yum
  fi

  echo "[+] Installing Java 11 and dependencies..." | tee -a "$LOG_FILE"
  $PKGM install -y java-11-openjdk wget curl

  echo "[+] Adding Jenkins repository..." | tee -a "$LOG_FILE"
  wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

  echo "[+] Installing Jenkins (latest)..." | tee -a "$LOG_FILE"
  $PKGM install -y jenkins

  systemctl enable jenkins
  systemctl restart jenkins
}

# Fedora/RedHat/CentOS/Amazon/Rocky/Alma/Oracle
case "$OS_ID" in
  ubuntu|debian|raspbian)
    install_debian_like
    ;;
  centos|rhel|amzn|rocky|almalinux|fedora|oracle)
    install_redhat_like
    ;;
  *)
    echo "[X] Unsupported Linux distribution: $OS_ID" | tee -a "$LOG_FILE"
    exit 1
    ;;
esac

# Report Jenkins status
if systemctl is-active --quiet jenkins; then
  IP=$(hostname -I | awk '{print $1}')
  echo "[✓] Jenkins is installed and running at: http://$IP:8080" | tee -a "$LOG_FILE"
else
  echo "[X] Jenkins installation finished, but service is NOT running." | tee -a "$LOG_FILE"
fi

echo "[+] Installation complete. Logs saved to $LOG_FILE"
