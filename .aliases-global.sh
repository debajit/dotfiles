#
# My ZSH global aliases.
#
# These are quick aliases that you can expand from any place in the
# shell. Type the letter and press Tab to expand it.
#
# To expand them inline in your command line, add the following line
# to your ~/.zshrc:
#
#   # Complete aliases inline by pressing Tab. See
#   # https://superuser.com/a/1514591/2041
#   zstyle ':completion:*' completer _expand_alias _complete _ignored
#

# Pipes
alias -g L='| less'
alias -g G='| grep'
alias -g C='| wc -l'
alias -g X='| xargs -0'

# Arguments
alias -g H='--help'
alias -g V='--version'

# Options
alias -g h='HEAD'
alias -g m='main'
alias -g n='--no-decorate'
alias -g om='origin/main'

case "${OSTYPE}" in
  linux*)
    alias -g P='| xclip -sel c -r'
    ;;
  darwin*)
    alias -g P='| pbcopy'
    ;;
esac
