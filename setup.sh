#!/usr/bin/env zsh

set -e
set -o pipefail

RUN_ODA_ENV=false

# Parse command line arguments
for arg in "$@"
do
    case $arg in
        --oda)
        RUN_ODA_ENV=true
        shift
        ;;
    esac
done

# Load OS detection logic
source ./os_type.sh

# Functions
install_ubuntu_packages() {
    echo "Installing Ubuntu packages..."
    while IFS= read -r package; do
        sudo apt-get install -y $package || { echo "Failed to install $package"; exit 1; }
    done < ubuntu_packages.txt
}

install_starship() {
    if command -v starship > /dev/null 2>&1; then
        echo "Starship is already installed. Skipping..."
    else
        echo "Installing Starship..."
        curl -fsSL https://starship.rs/install.sh | sh || { echo "Failed to install Starship"; exit 1; }
    fi
}

install_macos_packages() {
    echo "Installing macOS packages and casks..."
    brew bundle || { echo "Failed to install Brew bundles"; exit 1; }
}

setup_asdf() {
    echo "Setting up ASDF..."
    chmod +x asdf_setup.sh
    ./asdf_setup.sh || { echo "Failed to setup ASDF"; exit 1; }
}

update_git_config() {
    echo "Updating global git config..."
    cp .gitconfig ~/.gitconfig || { echo "Failed to copy .gitconfig"; exit 1; }
    cp .gitignore_global ~/.gitignore_global || { echo "Failed to copy .gitignore_global"; exit 1; }
}

setup_custom_env() {
    echo "Setting up custom environment..."
    if [[ -f oda_env.sh ]]; then
        source oda_env.sh || { echo "Failed to setup custom environment"; exit 1; }
    else
        echo "oda_env.sh not found. Skipping sourcing..."
    fi
}

install_oh_my_zsh_plugins() {
    echo "Installing oh-my-zsh plugins..."

    ZSH_AUTOSUGGESTIONS_DIR="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    ZSH_SYNTAX_HIGHLIGHTING_DIR="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

    if [[ -d "$ZSH_AUTOSUGGESTIONS_DIR" ]]; then
        echo "zsh-autosuggestions directory already exists. Skipping..."
    else
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGESTIONS_DIR"
    fi

    if [[ -d "$ZSH_SYNTAX_HIGHLIGHTING_DIR" ]]; then
        echo "zsh-syntax-highlighting directory already exists. Skipping..."
    else
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_HIGHLIGHTING_DIR"
    fi
}

install_docker() {
    # Install Docker
    if ! command -v docker &> /dev/null
    then
        echo "Installing Docker..."
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        sudo apt-get install -y docker-ce
        sudo usermod -aG docker $(whoami)
    fi

    # Install Docker Compose
    if ! command -v docker-compose &> /dev/null
    then
        echo "Installing Docker Compose..."
        sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
}

# Main
main() {
    if [[ -z "$OS" ]]; then
        echo "\$OS is empty or not set"
        exit 1
    else
        echo "\$OS is set and the value is: $OS"
    fi

    if [[ $OS == "ubuntu" ]];then
        sudo apt-get update || { echo "Failed to update Ubuntu"; exit 1; }
        install_ubuntu_packages
        install_starship
        install_docker
    elif [[ $OS == "macos" ]]; then
        install_macos_packages
    else
        echo "Unsupported OS: $OS"
        exit 1
    fi

    setup_asdf
    update_git_config
    install_oh_my_zsh_plugins

    # Set up the optional custom environment
    if $RUN_ODA_ENV; then
        setup_custom_env
    fi

    # Refresh the shell
    echo "Setup successfully ran"
    echo "Refreshing the shell..."
    exec zsh
}

main "$@"
