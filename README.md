# Dotfiles

My dotfiles to quickly configure my computing setup.

I’ve been using this setup successfully on a variety of systems, for almost a decade now:

- GNU operating systems (Arch, Manjaro, Ubuntu on WSL2, AmazonLinux, Synology NAS)
- macOS

GNU/Linux distribution checks are done as required to customize behavior and commands.

## Installation

Clone this repository and run `make`.

This will copy all the dotfiles into their appropriate places.

## Local dictionary for Emacs

Run `make dict` to install and start a local DICT server with GCIDE, WordNet,
Moby Thesaurus, Devil's Dictionary, Jargon, and FOLDOC.

- **macOS:** requires Homebrew. Installs `dict`, downloads ready-made dictionaries
  to `~/.dictd`, and enables the `local.dictd` LaunchAgent at login. The server
  listens only on `127.0.0.1:2628`. Dictionary data comes from a pinned
  [2018 snapshot](https://github.com/ferdnyc/dictd-dicts), not current editions.
- **Arch/Manjaro:** requires `paru` (install it with `make paru`). Uses `pacman`
  and AUR dictionary packages, then enables and restarts the `dictd` system service.

Run as your normal user. Rerunning is supported; macOS reuses downloaded data
and regenerates its configuration and service. An independently running server
on port 2628 must be stopped first. Other Linux distributions are not supported.

Configure Emacs 30+ with:

```elisp
(require 'dictionary)
(setopt dictionary-server "127.0.0.1"
        dictionary-search-interface 'help)
```

Use `M-x dictionary-search`, or test from a terminal with
`dict -h 127.0.0.1 hello`.

On macOS, logs are in `~/.dictd/dictd.log` and `~/.dictd/dictd-error.log`.
To stop it and disable startup, run:

```sh
launchctl bootout "gui/$(id -u)/local.dictd"
launchctl disable "gui/$(id -u)/local.dictd"
```

On Arch, use `sudo systemctl disable --now dictd`. Run `make dict` to re-enable.

## Uninstallation

From your local working directory for this repo, run

```bash
make uninstall
```
