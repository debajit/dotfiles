# Use saner defaults
alias cp='cp -iv'
alias df='df -h'                # Free disk space
alias du='du -khs'              # Disk usage
alias feh='feh -Zr'             # Fast image viewer
alias mkdir='mkdir -p'
alias rsync='rsync -aPvhs'
alias tmux='TERM=xterm-256color tmux'
alias vi='vim'

# General aliases
alias e='echo'
alias u="cd .. && pwd && ls"                         # cd “up” to the parent directory
alias w='tail -f /dev/null --pid=`pgrep rsync` && '  # Wait for a process

# Tools
alias f='ranger'                  # File manager
alias m="mpv"                     # Movie player
alias i="feh"                     # Image viewer
alias r='rsync -aPsh'
alias kdiff='kitty +kitten diff'  # See https://sw.kovidgoyal.net/kitty/kittens/diff.html

# Git
alias b='git branch'
alias c='git checkout'
alias s='git status'
alias d='git diff'
alias ds='git diff --staged'
alias p='git pull --rebase'
alias q="git q"                 # Quick short git log
alias re='git rebase'
alias g='git g'
alias gg='git gg'
alias ggg='git ggg'
alias gf='git gf'
alias fu='git fetch origin'     # Inspired by Magit’s shortcuts
alias ro='git rebase origin/master'
alias ru='git rebase "@{u}"'
alias tip='git log -1 --name-status'
alias x='git reset --hard'

# Git Annex
alias a='git annex'
alias aa='git annex add -J6'
alias ac='git annex copy --to b2 -J6'
alias ae='git annex enableremote'
alias ag='git annex get -J6'
alias al='git annex lock'
alias as='git annex sync'
alias au='git annex unlock'
alias aw='git annex whereis'
alias ax='git annex export main --to nas -J6'

# Git remotes
alias GCS="git clone git@git.sr.ht:~debajit/"
alias GCC="git clone git@codeberg.org:debajit/NAME.git"
alias GCD="git clone git@git.disroot.org:debajit/NAME.git"
alias GCG="git clone git@github.com:debajit/NAME.git"
alias GRS='git remote add srht git@git.sr.ht:~debajit/${PWD:t}'
alias GRC='git remote add codeberg git@codeberg.org:debajit/${PWD:t}.git'
alias GRD='git remote add disroot git@git.disroot.org:debajit/${PWD:t}.git'
alias GRG='git remote add github git@github.com:debajit/${PWD:t}.git'

# Misc
alias F="find -type f -iname '*.ext'"
alias FE="find -type f -iname '*.ext' -exec COMMAND --OPTIONS {} \;"
alias Q='cal -3 && date'        # Quick overview

# Backup
# alias B='duplicacy backup -threads 12 -stats'                                         # Backup
# alias D='duplicacy backup -threads 12 -dry-run -stats'                                # Dry-run backup
# alias R='duplicacy restore -ignore-owner -threads 12 -r'                              # Restore
# alias RA='duplicacy restore -ignore-owner -overwrite -delete -threads 12 -r'          # Restore all
# alias BP='duplicacy prune -threads 12 -keep 360:360 -keep 30:180 -keep 7:30 -keep 1:7' # Prune

# ls
alias ls='exa'
alias la='exa -la'              # Show all files, including dotfiles
alias ll='exa -l'               # Show long listing
alias lk='exa -l --sort size'   # Long listing by size, largest size at the bottom
alias lt='exa -l --sort newest' # Lists sorted by date, most recent last

# Navigation.
# Directory jumping. “1” to jump to the last dir and so on.
alias j='dirs -v'               # List recent dirs to jump to them quickly
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# Security
alias en='gpg --symmetric --cipher-algo AES256' # Encrypt

# Shell
alias Z='source "${HOME}/.zshrc"' # Reload ZSH configuration

# SSH
alias ssh-fingerprint-md5='ssh-keygen -l -E md5 -f'
alias ssh-fingerprint-sha='ssh-keygen -lf'

# Sync
alias R="rclone -PL sync --exclude '.*{/**,}'"                        # Rclone sync
# alias SS='rsync -srzvhP --exclude ".*" -A --no-perms --delete-after' # rsync Samba/CIFS

# Useful utility aliases
alias isp='curl ifconfig.co/json | jq .asn_org' # Show your ISP (experimental)
alias start-web-server='python3 -m http.server' # Start a web server from current dir. Port optional: `start-web-server 1111`

# YouTube
yt() { mpv ytdl://ytsearch:"$*" }                           # YouTube video
yta() { mpv --ytdl-format=bestaudio ytdl://ytsearch:"$*" }  # YouTube audio

# Aliases with OS-specific implementations
# See OS detection in https://stackoverflow.com/a/18434831/2288585
case "$OSTYPE" in
  # Linux
  linux*)
    alias df="df -Th"
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
    alias pp="brew info"        # Package info

    alias gk='sudo spctl --master-disable' # Disable GateKeeper
    ;;
esac

# Miscellaneous application-specific aliases (experimental)
alias ir='i -z'                    # Display images, in random order
alias tm='tmux a -d'               # Connect to tmux session
