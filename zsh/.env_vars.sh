export CXXFLAGS='-std=c++20'
# export MANPAGER="sh -c 'col -bx | bat -l man -p --paging always'"
export MAILDIR="$HOME/.mail"

# Bat
export BAT_THEME='gruvbox-dark'

# Docker
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# Gum
export GUM_FILTER_INDICATOR='⏺'

# OS-specific customization
case "$OSTYPE" in
  linux*) # GNU/Linux

    distro=$(grep -ioP '^ID=\K.+' /etc/os-release 2> /dev/null) # See https://unix.stackexchange.com/a/671133

    case "${distro}" in
      arch)
        export HOSTNAME="$(hostnamectl hostname)"
        ;;

      *) # All other GNU/Linux flavors
        export HOSTNAME="$(hostname)"
        ;;
    esac
    ;;

  darwin*) # macOS
    export HOSTNAME="$(hostname)"
    ;;
esac
