#
# fzf.
# See https://wiki.archlinux.org/index.php/Fzf
#
case "$OSTYPE" in
  # Linux
  linux*)
    source_file /usr/share/fzf/key-bindings.zsh # Arch-based distros
    source_file /usr/share/fzf/completion.zsh   # Arch-based distros
    source_file "${HOME}/.fzf.zsh"              # Other
    ;;

  # macOS
  darwin*)
    source_dotfile ".fzf.zsh"
    ;;
esac

#
# zoxide
# Directory autojump based on frecency.
#
# See https://github.com/ajeetdsouza/zoxide
#
if [[ -x "$(command -v zoxide)" ]]; then
  eval "$(zoxide init zsh)"
  eval "$(zoxide init posix --hook prompt)"
fi

# AWS CLI
source_file /usr/local/aws/bin/aws_zsh_completer.sh
