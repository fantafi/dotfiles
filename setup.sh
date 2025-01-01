#!/bin/sh

echo "Setuping up your Mac..."

# Install composer
# Check for Oh My Zsh and install if we don't have it
if test ! $(which composer); then
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
  sudo mv composer.phar /usr/local/bin/composer
fi

# Install Lavel Valet
if test ! $(which valet); then
  composer global require laravel/valet
fi

# Install NVM
if test ! $(which nvm); then
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
fi

# Install Rust
if test ! $(which rustup); then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Install Daytona
if test ! $(which daytona); then
  curl -sf -L https://download.daytona.io/daytona/install.sh | sudo bash
fi

# Install Daytona
if test ! $(which bun); then
  curl -fsSL https://bun.sh/install | bash
fi
