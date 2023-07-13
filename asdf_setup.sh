#!/usr/bin/env zsh

# Detect the operating system
. ./os_type.sh
if [[ -z "$OS" ]]; then
  echo "\$OS is empty or not set"
  exit 1
else
  echo "\$OS is set and the value is: $OS"
fi

# Check if asdf is installed
if ! command -v asdf &> /dev/null
then
  echo "ASDF - Installing..."
  
  if [[ "$OS" == "ubuntu" ]]; then
    mkdir -p ~/repos
    git clone https://github.com/asdf-vm/asdf.git ~/repos/.asdf
    cd ~/repos/.asdf
    # checkout latest tag, hopefully latest stable release
    git checkout "$(git describe --abbrev=0 --tags)"
    export PATH="$HOME/repos/.asdf/bin:$PATH"
    echo '. $HOME/repos/.asdf/asdf.sh' >> ~/.zshrc
    echo '. $HOME/repos/.asdf/completions/asdf.bash' >> ~/.zshrc
    source ~/.zshrc
  
  elif [[ "$OS" == "macos" ]]; then
    if ! command -v brew &> /dev/null
    then
      echo "brew command not found. Please install Homebrew first."
      exit 1
    fi
    brew install asdf
    export PATH="$(brew --prefix asdf)/bin:$PATH"
    echo -e "\n. $(brew --prefix asdf)/asdf.sh" >> ~/.zshrc
    echo -e "\n. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash" >> ~/.zshrc
  fi
else
  echo "asdf is already installed"
fi

cd ~/dot

while IFS= read -r line
do
  asdf plugin add $line
done < "asdf_packages.txt"

# Use asdf to install all the versions specified in .tool-versions
asdf install

# Import the Node.js release team's OpenPGP keys if nodejs is a plugin
if asdf plugin-list | grep -q "nodejs"
then
  zsh ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
fi

echo "ASDF - Setup complete"
