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
