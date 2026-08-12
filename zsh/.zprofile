# Executes commands at login, before .zshrc. This file owns all PATH
# additions; `typeset -U path` in .zshenv keeps them unique, so
# re-sourcing this file is harmless.

# Personal scripts and binaries, ahead of the system paths so they take
# precedence over same-named system commands.
for dir in "${HOME}/bin" "${HOME}/.local/bin"; do
  [[ -d "${dir}" ]] && path=("${dir}" ${path})
done
unset dir

case "$OSTYPE" in
  linux*)

    # Ruby Gems. See https://wiki.archlinux.org/title/Ruby#Setup
    if (( $+commands[ruby] )); then
      export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
      path=(${path} "${GEM_HOME}/bin")
    fi

    # Use the systemd user ssh-agent (systemctl --user enable --now ssh-agent.socket).
    # Combined with `AddKeysToAgent yes` in ~/.ssh/config, keys load on first use.
    if [[ -n "${XDG_RUNTIME_DIR}" && -S "${XDG_RUNTIME_DIR}/ssh-agent.socket" ]]; then
      export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
    fi

    # Graphical passphrase prompt instead of a TTY prompt, when a display is present
    if [[ -n "${DISPLAY}${WAYLAND_DISPLAY}" && -x /usr/lib/gcr4-ssh-askpass ]]; then
      export SSH_ASKPASS=/usr/lib/gcr4-ssh-askpass
      export SSH_ASKPASS_REQUIRE=prefer
    fi
    ;;

  darwin*)

    # Homebrew. Apple Silicon installs under /opt/homebrew, Intel under /usr/local.
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi

    # sdkman. Set SDKMAN_DIR only once we know the init script is really there,
    # so a missing formula does not leave a bogus path exported.
    if (( $+commands[brew] )); then
      sdkman_dir="$(brew --prefix sdkman-cli 2>/dev/null)/libexec"
      if [[ -s "${sdkman_dir}/bin/sdkman-init.sh" ]]; then
        export SDKMAN_DIR="${sdkman_dir}"
        source "${SDKMAN_DIR}/bin/sdkman-init.sh"
      fi
      unset sdkman_dir
    fi
    ;;
esac

# Machine-specific login settings (e.g. workplace env vars). Not
# tracked in this repo. Sourced last so it can override anything set
# above.
[[ -f "${HOME}/.zprofile.local" ]] && source "${HOME}/.zprofile.local"
