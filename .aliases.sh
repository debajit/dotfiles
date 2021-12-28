# Use saner defaults
alias cp='cp -iv'
alias df='df -Th'               # Free disk space
alias du='du -khs'              # Disk usage
alias feh='feh -Zr'             # Fast image viewer
alias mkdir='mkdir -p'
alias rsync='rsync -aPvhs'
alias tmux='TERM=xterm-256color tmux'
alias vi='vim'

#
# Quick one-letter aliases
#
# Related: (defined in .aliases-functions.sh)
# - t
#

# Shell
alias u="cd .. && pwd && ls"    # cd “up” to the parent directory

# Tools
alias f='ranger'                # File manager
alias m="mpv"                   # Movie player
alias i="feh"                   # Image viewer

# Git
alias c='git checkout'
alias s='git status'
alias d='git diff'
alias q="git q"                 # Quick short git log
alias g='git g'
alias gg='git gg'
alias ggg='git ggg'
alias gf='git gf'
alias gs='git annex sync --content'

# Misc
alias F="find . -iname '.*'"
alias Q='cal -3 && date'        # Quick overview

# Sync
alias rsync-full='rsync --delete-after'
alias R="rclone -P sync --exclude '.*{/**,}'"                        # Rclone sync
# alias SS='rsync -srzvhP --exclude ".*" -A --no-perms --delete-after' # rsync Samba/CIFS

# Backup
# alias B='duplicacy backup -threads 12 -stats'                                         # Backup
# alias D='duplicacy backup -threads 12 -dry-run -stats'                                # Dry-run backup
# alias R='duplicacy restore -ignore-owner -threads 12 -r'                              # Restore
# alias RA='duplicacy restore -ignore-owner -overwrite -delete -threads 12 -r'          # Restore all
# alias BP='duplicacy prune -threads 12 -keep 360:360 -keep 30:180 -keep 7:30 -keep 1:7' # Prune

# Git. Inspired by Magit’s shortcuts in Emacs.
alias ds='git diff --staged'
alias fu='git fetch origin'
alias ru='git rebase "@{u}"'
alias tip='git log -1 --name-status'

# Git remotes
alias GCS="git clone git@git.sr.ht:~debajit/"
alias GCC="git clone git@codeberg.org:debajit/NAME.git"
alias GCD="git clone git@git.disroot.org:debajit/NAME.git"
alias GCG="git clone git@github.com:debajit/NAME.git"
alias GRS='git remote add srht git@git.sr.ht:~debajit/${PWD:t}'
alias GRC='git remote add codeberg git@codeberg.org:debajit/${PWD:t}.git'
alias GRD='git remote add disroot git@git.disroot.org:debajit/${PWD:t}.git'
alias GRG='git remote add github git@github.com:debajit/${PWD:t}.git'

# ls
alias ls='exa'
alias la='exa -la'              # Show all files, including dotfiles
alias ll='exa -l'               # Show long listing
alias lk='exa -l --sort size'   # Long listing by size, largest size at the bottom
alias lt='exa -l --sort newest' # Lists sorted by date, most recent last

# YouTube
yt() { mpv ytdl://ytsearch:"$*" }                           # YouTube video
yta() { mpv --ytdl-format=bestaudio ytdl://ytsearch:"$*" }  # YouTube audio

# ssh
alias ssh-fingerprint-md5='ssh-keygen -l -E md5 -f'
alias ssh-fingerprint-sha='ssh-keygen -lf'

# Aliases with OS-specific implementations
# See OS detection in https://stackoverflow.com/a/18434831/2288585
case "$OSTYPE" in
  # Linux
  linux*)
    alias open="xdg-open"
    alias pi="pamac install"   # Package install
    alias pr="pamac remove"    # Package remove/uninstall
    alias pq="pamac search"    # Package query/search/info
    alias pp="pamac info"      # Package info
    ;;

  # macOS
  darwin*)
    alias pi="brew install"     # Package install
    alias pr="brew uninstall"   # Package remove/uninstall
    alias pq="brew search"      # Package query/search/info
    alias pu="brew upgrade"     # Upgrade a single package

    alias gk='sudo spctl --master-disable' # Disable GateKeeper
    ;;
esac

# Directory jumping. “1” to jump to the last dir and so on.
alias j='dirs -v'               # List recent dirs to jump to them quickly
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# Other aliases
alias kdiff='kitty +kitten diff'   # See https://sw.kovidgoyal.net/kitty/kittens/diff.html
alias ir='i -z'                    # Display images, in random order
alias tm='tmux a -d'               # Connect to tmux session

#
# Useful utility aliases
#

alias isp='curl ifconfig.co/json | jq .asn_org'

# Start web server from current dir. Port optional: `start-web-server 1111`
alias start-web-server='python3 -m http.server'
