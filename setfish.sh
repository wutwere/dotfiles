#!/usr/bin/bash
if command -v fish &>/dev/null; then
  if ! grep -q "$(command -v fish)" /etc/shells; then
    echo "Adding Fish to available shells..."
    sudo sh -c "echo $(command -v fish) >> /etc/shells"
  fi
  read -p "Do you want to set Fish as your default shell? (y/N): " -n 1 -r
  echo # Move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    chsh -s "$(command -v fish)"
  fi
else
  echo "Fish is not installed."
fi
