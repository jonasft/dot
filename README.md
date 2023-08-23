! Disclaimer: This file was generated by ChatGPT and might not be accurate.

# Jonas's Dotfiles Repository

This repository contains configuration files, scripts, and tools for setting up and managing Jonas's development environment.

## Overview

- **Dotfiles**: Essential configuration files for tools like git and zsh.
- **Scripts**: Bash scripts to automate the installation and setup of necessary software, depending on the OS.
- **Package Lists**: Lists of software packages to be installed for Ubuntu and MacOS.

## Prerequisites

- **Git**: Ensure that Git is installed on your system to clone this repository.
- **Zsh**: Some scripts utilize the Zsh shell. It's advisable to have it installed, or the scripts will install it for you.

## Getting Started

1. **Clone the Repository**

   First, clone this repository to your local machine.

   ```zsh
   git clone git@github.com:jonasft/dot.git
   cd dot
   ```

2. **Run the Setup Script**

   This script will detect your operating system, install necessary packages, and set up your environment.

   ```zsh
   chmod +x setup.sh
   ./setup.sh
   ```

   > **Note**: The script will attempt to identify whether you are running on a MacOS or Ubuntu system and act accordingly. Ensure you're running the script on one of these systems or be ready to make necessary modifications.

3. **What the Setup Script Does**

   - Installs Zsh if not present and sets it as the default shell.
   - Installs `oh-my-zsh`.
   - Sets up ASDF version manager.
   - Depending on the OS:
     - **MacOS**: Installs packages and casks from the `Brewfile`.
     - **Ubuntu**: Installs packages listed in `ubuntu_packages.txt` and sets up additional tools like Docker.

4. **Manual Steps**

   After running the setup script, ensure to:

   - Restart or open a new terminal for all changes to take effect.
   - Check any additional configurations or aliases added to the `.zshrc`.

## Contribution

Feel free to fork this repository and customize it to your needs. Pull requests and enhancements are welcome.