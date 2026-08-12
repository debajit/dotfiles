# Keep PATH free of duplicates. This attribute sticks to the array for
# the life of the shell, so every later addition (.zprofile, .zshrc,
# cargo, nix) is deduplicated automatically.
typeset -U path

#-----------------------------------------------------------------------
# Set SESSION_TYPE
# Adapted from https://unix.stackexchange.com/a/9607/141850 by mkhatib
#-----------------------------------------------------------------------

if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
  SESSION_TYPE="remote/ssh"
else
  case $(ps -o comm= -p "$PPID") in
    sshd|*/sshd)
      SESSION_TYPE="remote/ssh"
      ;;
  esac
fi

# Homebrew and the personal bin directories live in .zprofile, which owns
# all PATH additions.

[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
