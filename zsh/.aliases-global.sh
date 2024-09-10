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
# awk -F, '$3 == "something" {print $1 " " $2 " " $3 " " $7}' | sort | uniq | column -t
alias -g AA="| awk -F ',' 'NR > 1 {print \$3}'"

# Awk: Rows with non-empty column 8
# alias -g AF="| awk -F ',' 'NR==1 || \$8 != "
alias -g AC="| awk -F ',' -v var='VAL' 'NR > 1 || \$4 == var {print \$3}'"
alias -g C='| wc -l'
alias -g S='| sort '
alias -g U='| uniq '
alias -g F='| fzf --tac --ansi'
alias -g T='| column -t'
alias -g T='|& tee /tmp/out.log'
alias -g J='| jq'
alias -g JL='| jq -C | less -R'
alias -g W='| less -S'          # Do not Wrap
alias -g X='| xargs -n1 '
alias -g B='| base64 -d'

# Arguments
alias -g H='--help'
alias -g V='--version'

# Options
alias -g h='HEAD'
alias -g m='master'
alias -g n='--no-decorate'
alias -g om='origin/master'

# Output
alias -g se='2> /dev/null'      # Suppress error (stderr)

# Override options for syntax highlighting.
# See https://github.com/sharkdp/bat
# alias -g -- -h='-h 2>&1 | bat --language=help --style=plain' # This breaks commands or aliases like df -h
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# Notifications
alias -g N='notify'
alias -g ND='notify "Downloaded"'
alias -g NT='notify "Transferred"'

case "${OSTYPE}" in
  linux*)
    # alias -g P='| xclip -sel c -r'  # For X11
    alias -g P='| wl-copy'            # For Wayland. See https://github.com/bugaevc/wl-clipboard
    ;;
  darwin*)
    alias -g P='| pbcopy'
    ;;
esac
