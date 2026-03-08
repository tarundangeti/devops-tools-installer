# 1. Fetch the latest version tag from GitHub API
export LATEST_VERSION=$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)

# 2. Download the binary using the detected version
# Note: You can replace 'all' with a specific provider like 'aws' or 'google' if preferred
wget "https://github.com/GoogleCloudPlatform/terraformer/releases/download/${LATEST_VERSION}/terraformer-all-linux-amd64"

# 3. Make it executable and move to your path
chmod +x terraformer-all-linux-amd64
sudo mv terraformer-all-linux-amd64 /usr/local/bin/terraformer

# 4. Verify installation
terraformer --version
