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
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# AWS CLI
source_file /usr/local/aws/bin/aws_zsh_completer.sh

# Python
# See https://medium.com/analytics-vidhya/setting-up-python-environment-in-macos-using-pyenv-and-pipenv-116293da8e72
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
