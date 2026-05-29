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

# Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Personal scripts and binaries
for dir in "${HOME}/.local/bin" "${HOME}/bin"; do
  [[ -d "${dir}" ]] && export PATH="${PATH}:${dir}"
done


[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
