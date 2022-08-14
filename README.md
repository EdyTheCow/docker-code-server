<p align="center">
  <img width="400" src="https://raw.githubusercontent.com/BeefBytes/Assets/master/Other/container_illustration/v2/dockerized_vscode.png">
</p>

# 📚 About
There’s already plenty of code-server docker setups out there, what’s the point of this? Well, every single alternative I found was either focused on a specific development environment or it had too much going on, with bunch layers of stuff I was never going to use. 

I wanted something barebones and simple, there’s no custom base images, no extra features you’ll never use. The whole image consists of a Dockerfile and entrypoint.sh, that’s it. 

The idea behind this setup is running code-server behind Traefik reverse proxy with docker extension installed on vscode. From code-server you’ll be able to spin up any kind of container and develop without ever installing node, python or whatever else on your system.

# 🧰 Getting Started
The guide assumes you already know basics of docker and docker compose. The reason Traefik and code-server compose files are split up, is to keep things modular in case you already run Traefik on your system.

## Requirements
- Domain
- [Docker](https://docs.docker.com/engine/install/#server)
- Docker Compose (comes with Docker Engine now)

# 🏗️ Installation

### Preparations / Setting up Traefik
You can skip this part in case you already have Traefik running. However, it may be still useful to look at the configuration on the repo in case you're having issues.

<b>Clone repository</b><br />
```
git clone https://github.com/EdyTheCow/docker-code-server.git
```

<b>Set correct acme.json permissions</b><br />

Navigate to `_base/data/traefik/` and run
```
sudo chmod 600 acme.json
```

<b>Setup basic auth</b><br />
Basic auth provides extra layer of security on top of code-server authentication.
Generate htpasswd and copy it to `_base/data/traefik/.htpasswd`

<b>Start docker compose</b><br />
Inside of `_base/compose` run
 ```
docker-compose up -d
 ```

### Setup code-server

<b>Configure variables</b><br />

Navigate to `code-server/compose/.env` and set these variables

| Variable | Description |
|-|-|
| DOMAIN | Domain you're going to use to access the code-server |
| PASSWORD | Password for code-server |

<b>Configure container user</b><br />
The container itself runs a non-root user you'll have to specify in `code-server/compose/docker-compose.yml`. In order to pass docker cli permissions on to container you'll have to specify your docker group ID.

<b>Example: `user: "1000:999"`</b><br />
1000 being your user ID and 999 being your docker group ID.

The `DOCKER_USER=${USER}` variable is meant to take your current user's username and pass it on to the container. Meaning you'll have your username from host automatically setup inside container. You can however remove the variable from `docker-compose.yml` alltogether and it will use username `coder` instead.

<b>Start docker compose</b><br />
 ```
docker-compose up -d
 ```
You can now navigate to `DOMAIN` you set earlier to access code-server. You can now open terminal and continue setup of zsh and Oh My Zsh.

### Setup Oh My Zsh theme
By default image installs zsh and Oh My Zsh with a powerlevel10k theme, so you'll have a fancy terminal inside of coder-server. 

<b>Install font for Oh My Zsh theme</b><br />
Download the font, install it and set it in code-server. You can follow the Visual Studio Code guide provided in the same link as the font.<br />
https://github.com/romkatv/powerlevel10k#manual-font-installation

<b>Open .zshrc and change theme to</b><br />
`ZSH_THEME="powerlevel10k/powerlevel10k"`<br />
You can also use any other theme if you prefer something else.

Installing font for Oh My Zsh theme
https://github.com/romkatv/powerlevel10k#manual-font-installation

## Post-installation
You can now install Docker and any other extensions you might want.

### Example of finished set-up
<p>
  <img width="600" src="https://i.imgur.com/fLjvVRn.png">
</p>

# 🐛 Known issues
- None so far 👀

