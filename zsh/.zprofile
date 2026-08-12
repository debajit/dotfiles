# Personal scripts and binaries
for dir in "${HOME}/.local/bin" "${HOME}/bin"; do
  [[ -d "${dir}" ]] && export PATH="${PATH}:${dir}"
done

case "$OSTYPE" in
  linux*)

    # Ruby Gems. See https://wiki.archlinux.org/title/Ruby#Setup
    if (( $+commands[ruby] )); then
      export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
      export PATH="$PATH:$GEM_HOME/bin"
    fi

    # Use the systemd user ssh-agent (systemctl --user enable --now ssh-agent.socket).
    # Combined with `AddKeysToAgent yes` in ~/.ssh/config, keys load on first use.
    [[ -S "${XDG_RUNTIME_DIR}/ssh-agent.socket" ]] && export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

    # Graphical passphrase prompt instead of a TTY prompt, when a display is present
    if [[ -n "${DISPLAY}${WAYLAND_DISPLAY}" && -x /usr/lib/gcr4-ssh-askpass ]]; then
      export SSH_ASKPASS=/usr/lib/gcr4-ssh-askpass
      export SSH_ASKPASS_REQUIRE=prefer
    fi
    ;;

  darwin*)

    # Homebrew
    [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

    # sdkman
    if (( $+commands[brew] )); then
      export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
      [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
    fi
    ;;
esac

# Machine-specific login settings (e.g. workplace env vars). Not tracked in this
# repo. Sourced last so it can override anything set above.
[[ -f "${HOME}/.zprofile.local" ]] && source "${HOME}/.zprofile.local"
