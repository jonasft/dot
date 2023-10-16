#!/usr/bin/env zsh

# Detect the operating system
. ./os_type.sh
if [[ -z "$OS" ]]; then
  echo "\$OS is empty or not set"
  exit 1
else
  echo "\$OS is set and the value is: $OS"
fi

# Ensure up to date
if [[ $OS == "ubuntu" ]];then
    sudo apt-get update
fi

# Handle macOS-specific items
if [[ $OS == "macos" ]]; then
    # Install brew packages and casks
    brew bundle
fi

# Handle Ubuntu-specific items
if [[ $OS == "ubuntu" ]]; then
    # Read from ubuntu_packages.txt and install each package
    while IFS= read -r package; do
        sudo apt-get install -y $package
    done < ubuntu_packages.txt

    # Install starship
    curl -fsSL https://starship.rs/install.sh | bash
fi

# Set up asdf
chmod +x asdf_setup.sh
./asdf_setup.sh

# Update the global git config
cp .gitconfig ~/.gitconfig

# Copy the git ignore file
cp .gitignore_global ~/.gitignore_global

# Set up the custom environment
source oda_env.sh

# Refresh the shell
exec zsh
