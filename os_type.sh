#!/usr/bin/env zsh

# Detect the operating system
if [[ "$OSTYPE" == "darwin"* ]]; then
  export OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export OS="ubuntu"
else
  echo "Unsupported operating system."
  exit 1
fi