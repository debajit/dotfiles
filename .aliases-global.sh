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
alias -g LL='--color=always | less -R'
alias -g G='| grep'
alias -g A="| awk '{ print \$1 }'"
alias -g C='| wc -l'
alias -g F='| fzf --tac --ansi'
alias -g T='| column -t'
alias -g J='| jq'
alias -g X='| xargs -0'
alias -g D='| base64 -d'

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
    # alias -g P='| xclip -sel c -r'  # For X11
    alias -g P='| wl-copy'            # For Wayland. See https://github.com/bugaevc/wl-clipboard
    ;;
  darwin*)
    alias -g P='| pbcopy'
    ;;
esac
