#!/bin/bash

# mac_system_update.sh
# 2023-09-26
# 2025-02-21 Update with many more tools/frameworks
# Purpose: Updating macOS packages and development tools

# Usage example:
# install_package git
install_package() {
    if ! brew list --formula | grep -q "^$1$"; then
        brew install "$1"
    else
        echo "$1 is already installed."
    fi
}

# Usage example:
# install_cask pgadmin4
install_cask() {
    if ! brew list --cask | grep -q "^$1$"; then
        brew install --cask "$1"
    else
        echo "$1 is already installed."
    fi
}

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
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing NVM..."
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    source ~/.nvm/nvm.sh
fi
nvm install node
nvm use node
find $(npm root -g) -name ".DS_Store" -delete
npm install -g npm
npm update -g

# -----------------------------
# Install .NET and Tools
# -----------------------------
echo "Setting up .NET..."
install_cask dotnet

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
brew install --cask angry-ip-scanner keepassxc veracrypt wireshark

# File Management & Utilities
brew install --cask easyfind exifcleaner blackhole-2ch macfuse wkhtmltopdf

# Development & Database
brew install --cask mjml postman oracle-jdk@21 jetbrains-toolbox visual-studio-code pgadmin4

# Library Management
brew install --cask calibre

# Media & Streaming
brew install --cask imageoptim obs transmission vlc qview

# Automation & System Tools
brew install --cask hammerspoon

# Coding Fonts
brew install --cask font-fira-code font-fira-mono font-fira-sans font-fira-sans-condensed font-fira-sans-extra-condensed
brew install --cask font-hack font-hack-nerd-font
brew install --cask font-jetbrains-mono font-jetbrains-mono-nerd-font
brew install --cask font-cascadia-code font-cascadia-code-nf font-cascadia-mono font-cascadia-mono-nf
brew install --cask font-meslo-lg

# Sans-serif Fonts
brew install --cask font-inter font-inter-nerd-font font-inter-extra-light font-inter-light font-inter-medium font-inter-semi-bold font-inter-thin
brew install --cask font-roboto font-roboto-condensed font-roboto-mono font-roboto-slab
brew install --cask font-open-sans font-open-sans-condensed font-open-sans-extra-bold font-open-sans-light font-open-sans-semi-bold
brew install --cask font-noto-sans 

# Serif Fonts
brew install --cask font-ibm-plex-serif font-ibm-plex-serif-condensed font-ibm-plex-serif-extra-light font-ibm-plex-serif-light font-ibm-plex-serif-medium font-ibm-plex-serif-semi-bold font-ibm-plex-serif-thin
brew install --cask font-merriweather font-merriweather-sans font-merriweather-serif
brew install --cask font-playfair-display font-playfair-display-sc 
brew install --cask font-source-serif-pro font-source-serif-pro-nerd-font

# Decorative Fonts
brew install --cask font-comic-code font-comic-neue font-comic-neue-angular font-comic-neue-hk font-comic-neue-hk-angular font-comic-neue-hk-sc font-comic-neue-hk-sc-angular
brew install --cask font-lobster font-lobster-two font-lobster-two-nerd-font
brew install --cask font-pacifico font-pacifico-nerd-font
brew install --cask font-raleway font-raleway-dots font-raleway-nerd-font font-raleway-thin font-raleway-thin-dots


# -----------------------------
# Finalize
# -----------------------------
brew cleanup

echo "System update complete!"
