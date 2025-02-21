#!/bin/bash

# mac_system_update.sh
# 2023-09-26
# Purpose: Updating macOS packages and development tools

echo "Starting to update system..."

# Install Homebrew if not already installed
echo "Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# Update Homebrew and installed packages
echo "Updating Homebrew..."
brew update && brew upgrade && brew cleanup

# -----------------------------
# Install General Utilities
# -----------------------------
brew install git git-lfs wget
brew install rclone tailscale youtube-dl yt-dlp
brew install hugo

# -----------------------------
# Install Python and Tools
# -----------------------------
echo "Setting up Python..."
brew install python
brew install pipx
pipx ensurepath
brew install pyenv

# Configure pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
source ~/.zshrc

# Install the latest Python version via pyenv
pyenv install 3.12.0
pyenv global 3.12.0

# Install common Python tools
pipx install poetry
pipx install virtualenv
pipx install black
pipx install flake8

# -----------------------------
# Install Java and Tools
# -----------------------------
echo "Setting up Java..."
brew install openjdk maven gradle jenv

# Configure Java environment
echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> ~/.zshrc
echo 'export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"' >> ~/.zshrc
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(jenv init -)"' >> ~/.zshrc
source ~/.zshrc

# Add OpenJDK to jenv
jenv add /opt/homebrew/opt/openjdk
jenv global $(ls /Library/Java/JavaVirtualMachines | grep jdk | head -n 1)

# -----------------------------
# Install Node.js and Tools
# -----------------------------
echo "Setting up Node.js..."
brew install nvm
mkdir -p ~/.nvm
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"' >> ~/.zshrc
echo '[ -s "/opt/homebrew/opt/nvm/etc/bash_completion" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion"' >> ~/.zshrc
source ~/.zshrc

nvm install node
nvm use node
find $(npm root -g) -name ".DS_Store" -delete
npm install -g npm
npm update -g

# -----------------------------
# Install .NET and Tools
# -----------------------------
echo "Setting up .NET..."
brew install dotnet

echo 'export PATH="$HOME/.dotnet/tools:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Install common .NET global tools
dotnet tool install --global dotnet-outdated-tool
dotnet tool install --global dotnet-format
dotnet tool install --global dotnet-ef
dotnet tool install --global dotnet-sonarscanner

# -----------------------------
# Install applications
# -----------------------------
# Networking & Security Tools
brew install --cask angry-ip-scanner keepassxc veracrypt 

# File Management & Utilities
brew install --cask easyfind exifcleaner blackhole-2ch macfuse wkhtmltopdf 

# Development & Programming
brew install --cask mjml postman oracle-jdk@21 

# Database & Productivity
brew install --cask pgadmin4 calibre qview 

# Media & Streaming
brew install --cask imageoptim obs transmission 

# Automation & System Tools
brew install --cask hammerspoon

echo "System update complete!"
