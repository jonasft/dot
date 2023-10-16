#!/bin/bash

set -e

# Detect the operating system
if [[ "$OSTYPE" == "darwin"* ]]; then
  export OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export OS="ubuntu"
else
  echo "Unsupported operating system."
  exit 1
fi

# Ensure zsh is installed
if ! command -v zsh &> /dev/null
then
    if [[ $OS == "ubuntu" ]]; then
        sudo apt-get install -y zsh
    elif [[ $OS == "macos" ]]; then
        brew install zsh
    fi
fi

# Make zsh the default shell
chsh -s $(which zsh)

# Ensure oh-my-zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Copy the .zshrc file
cp .zshrc ~/.zshrc
