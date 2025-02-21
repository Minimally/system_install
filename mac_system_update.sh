#!/bin/bash

# mac_system_update.sh
# 2023-09-26
# Purpose: Updating macos packages and things

echo "Starting to update system..."

# Update Homebrew packages
if command -v brew > /dev/null 2>&1; then
  echo "Updating Homebrew..."
  brew update
  brew upgrade
  brew cleanup
else
  echo "Homebrew not installed!"
fi

echo "System update complete!"
