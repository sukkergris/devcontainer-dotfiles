# Devcontainer dotfiles

This repository is used exclusively inside VS Code devcontainers. It is the
container half of a two-dotfiles setup:

- Host dotfiles manage the Mac: shell, SSH, Git, host tools, and other local
  machine configuration.
- Devcontainer dotfiles manage the container environment: shell config, editor
  config, aliases, container tool config, and similar development defaults.

## Scope

This repo manages configuration that should exist inside the devcontainer, such
as:

- zsh and bash startup files
- shared shell aliases
- editor configuration, including Neovim
- container-specific tool configuration, such as .NET settings
- git configuration, if a container-specific package is added

Each top-level package directory is a GNU Stow package. `.install.sh` stows the
package directories into `$HOME` after backing up selected shell startup files.

## SSH

This repo does not manage `~/.ssh`.

SSH belongs to the host dotfiles and the devcontainer setup. Inside
devcontainers, `~/.ssh` is populated from the host through the devcontainer
mount and `copy-ssh-files.sh`, not through Stow.

Do not add an `ssh/` stow package here. VS Code can inject the host
`~/.ssh/config` as a real file before `.install.sh` runs; if this repo also
tries to stow `~/.ssh/config`, Stow sees a conflict and aborts the install.

## How to consume

Your container must have:

- git
- stow

Add these user settings in VS Code:

```json
{
  "dotfiles.installCommand": ".install.sh",
  "dotfiles.repository": "https://github.com/sukkergris/devcontainer-dotfiles.git"
}
```

## How to develop

1. Run the devcontainer.
2. Add new container-scoped config as a top-level Stow package directory.
3. Make sure the VS Code profile used for development is not also using this
   repo through the `dotfiles` settings. If you find a `~/dotfiles` directory in
   the devcontainer, remove those settings from that profile.

## Logging

`.install.sh` logs all output to `~/.devcontainer/logging/install.log` inside
the container. Each run appends a timestamped block:

```
========================================
dotfiles install started: 2026-05-01T09:34:12+02:00
log: /root/.devcontainer/logging/install.log
========================================
```

To read the log from inside the container:

```sh
cat ~/.devcontainer/logging/install.log
```

## References

- [VS Code Dev Containers dotfiles documentation](https://code.visualstudio.com/docs/devcontainers/containers#_personalizing-with-dotfile-repositories)
- [Share Git credentials with your container and use SSH access](https://dev.to/sukkergris/share-git-credentials-with-your-container-and-use-ssh-access-1180)
