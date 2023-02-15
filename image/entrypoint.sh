#!/bin/sh
set -eu
eval "$(fixuid -q)"

if [ ! -d /home/coder/workspace ]; then
  mkdir -p /home/coder/workspace
fi

# If CONTAINER_USER is set and if user doesn't exist already, switch container's user to match host's user
if [ "${CONTAINER_USER-}" ] && ! grep -q "^$CONTAINER_USER:" /etc/passwd; then
  echo "$CONTAINER_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/nopasswd > /dev/null
  sudo usermod --login "$CONTAINER_USER" coder
  sudo groupmod -n "$CONTAINER_USER" coder
  USER="$CONTAINER_USER"
  sudo sed -i "/coder/d" /etc/sudoers.d/nopasswd
fi

# Install Oh My Zsh
if [ ! -d /home/coder/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/coder/.oh-my-zsh/custom/themes/powerlevel10k
  git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins.git /home/coder/.oh-my-zsh/custom/plugins/autoupdate
fi

# Create certs if enabled, this is only useful if running locally without Traefik
if [ ${HTTPS_ENABLED} = "true" ]
  then
    dumb-init /usr/bin/code-server \
      --bind-addr "${APP_BIND_HOST}":"${APP_PORT}" \
      --cert /home/coder/.certs/cert.pem \
      --cert-key /home/coder/.certs/key.pem \
      /home/coder/workspace
else
    dumb-init /usr/bin/code-server \
      --bind-addr "${APP_BIND_HOST}":"${APP_PORT}" \
      /home/coder/workspace
fi