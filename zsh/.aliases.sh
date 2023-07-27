#
# Aliases.
#
# Most of the one-letter or two-letter aliases are generally meant to
# be used by pressing a Tab after typing them to be able to change
# their arguments on the fly and have a more meaningful command
# history. (See .zsh-config in this repo for the Zsh Tab
# autocompletion features configured).
#

# Use saner defaults
alias cp='cp -iv'
alias df='df -h'                # Free disk space
alias du='du -khs'              # Disk usage
alias feh='feh -Zr'             # Fast image viewer
alias mkdir='mkdir -p'
alias tmux='TERM=xterm-256color tmux'
alias vi='vim'
[[ "$TERM" == 'xterm-kitty' ]] && alias ssh='kitty +kitten ssh'

# General aliases
alias e='emacsclient'                               # Edit file in existing Emacs server session
alias j='zi'                                        # Jump quickly to recently used directories
alias u="cd .. && pwd && ls"                        # cd “up” to the parent directory
alias w='tail -f /dev/null --pid=`pgrep rsync` && ' # Wait for a process
alias wa='tail -f /dev/null --pid=`pgrep aria2c` && '  # Wait for a process
alias rme='fd -te -X rm -r'                         # Remove empty directories and files

# Tools
alias f='ranger'                  # File manager
alias m="mpv"                     # Movie player
alias i="feh"                     # Image viewer
alias r='rsync -aPvhs --exclude-from ~/.rsync-exclude.lst'
alias rl='rsync -aPvhsL --exclude-from ~/.rsync-exclude.lst'
alias kdiff='kitty +kitten diff'  # See https://sw.kovidgoyal.net/kitty/kittens/diff.html
alias icat="kitty +kitten icat"   # See https://sw.kovidgoyal.net/kitty/kittens/icat/

# Git
alias b='git branch'
alias c='git checkout'
alias s='git status'
alias d='git diff'
alias ds='git diff --staged'
alias p='git pull --rebase'
alias q="git q"                 # Quick short git log
alias re='git rebase'
alias gc='git clone'
alias g='git g'
alias gg='git gg'
alias ggg='git ggg'
alias gf='git gf'
alias fu='git fetch origin'     # Inspired by Magit’s shortcuts
alias ro='git rebase origin/master'
alias ru='git rebase "@{u}"'
alias tip='git log -1 --name-status'
alias x='git reset --hard'
alias GP="git l | gum filter | awk '{ print \$2 }'" # Git: pick commit

# Git Annex
alias a='git annex'
alias aa='git annex add -J24'
alias ac='git annex find --not --in b2 --print0 | xargs -0 git annex copy --to b2 -J6'
alias ad='git annex drop -J6'
alias ae='git annex enableremote'
alias ag='git annex get -J6'
alias al='git annex lock'
alias an='git annex find --not --in b2'
alias as='git annex sync'
alias au='git annex unlock'
alias aw='git annex whereis'
alias ax='git annex export HEAD --to nas -J24'

# Git remotes
alias GCS="git clone git@git.sr.ht:~debajit/"
alias GCC="git clone git@codeberg.org:debajit/NAME.git"
alias GCD="git clone git@git.disroot.org:debajit/NAME.git"
alias GCG="git clone git@github.com:debajit/NAME.git"
alias GRS='git remote add srht git@git.sr.ht:~debajit/${PWD:t}'
alias GRC='git remote add codeberg git@codeberg.org:debajit/${PWD:t}.git'
alias GRD='git remote add disroot git@git.disroot.org:debajit/${PWD:t}.git'
alias GRG='git remote add github git@github.com:debajit/${PWD:t}.git'

# Docker
alias DS='systemctl status --user docker'
alias DP='docker ps'

# Btrfs
alias bl='sudo btrfs subvolume list -t .'        # btrfs list subvolumes
alias bm='findmnt -t btrfs'                      # btrfs mounts (useful to see runtime mounts like for TimeShift)
alias bs='sudo btrfs subvolume show'             # btrfs show subvolume details
alias bd='sudo btrfs subvolume delete'           # btrfs delete snapshot (subvolume)
alias bu='btrfs filesystem usage'                # btrfs disk usage
alias DF='btrfs filesystem usage . | grep Free'  # btrfs free space available on disk

# Misc
alias F="find -type f -iname '*.ext'"
alias FE="find -type f -iname '*.ext' -exec COMMAND --OPTIONS {} \;"
alias Q='cal -3 && date'        # Quick overview
alias S='systemctl'
alias se='systemctl enable'
alias sd='systemctl disable'
alias sr='systemctl restart'
alias sl='systemctl list-units'
alias ss='systemctl status'
alias st='systemctl start'
alias sp='systemctl stop'

# Backup
backup_command='borg create -v --stats --progress --exclude-from $HOME/.borg-exclude.lst ::archive-{hostname}-{now} \
    $HOME/.emacs.d \
    $HOME/.zsh* \
    $HOME/.aliases* \
    $HOME/.env_vars* \
    $HOME/.paths* \
    $HOME/.app-config* \
    $HOME/.config/cmus/* \
    $HOME/.config/espanso/* \
    $HOME/.config/ranger/* \
    $HOME/.config/rclone/* \
    $HOME/{.config,.local/share}/liferea \
    $HOME/.hunspell_en_US \
    $HOME/.local/share/Anki2 \
    $HOME/.local/share/fonts/* \
    $HOME/Archive/Knowledge \
    $HOME/Projects \
    /etc/hosts \
    /etc/fstab'
alias B="${backup_command}"       # Backup
alias BC="${backup_command}"      # Since B may be overridden in .aliases.local.sh
alias BD="${backup_command/--stats --progress/--list --dry-run}"
alias BL='borg list --last 10'
alias BLG="borg list --last 10 -a '*gnu*'"
alias BLW="borg list --last 10 -a '*tw*'"
alias TL='sudo timeshift --list'
alias TC='sudo timeshift --check'

# Restore from backups.
# borg extract --list ::ARCHIVE 're:snippets'
# to extract only paths with the substring 'snippets'
alias BR='borg extract --list ::'
alias BRD='borg extract --list --dry-run ::'

# Prune backups
backup_prune_command='borg prune --stats --progress \
    --glob-archives "archive-{hostname}-*" \
    --keep-last=5 \
    --keep-daily=7 \
    --keep-weekly=4 \
    --keep-monthly=6 \
    --keep-yearly=1'
alias BP="${backup_prune_command}"                                         # Prune backups
alias BPD="${backup_prune_command/--stats --progress/-v --list --dry-run}" # Dry-prune backups
# TODO: Add `borg compact` aliases

# alias B='duplicacy backup -threads 12 -stats'                                         # Backup
# alias D='duplicacy backup -threads 12 -dry-run -stats'                                # Dry-run backup
# alias R='duplicacy restore -ignore-owner -threads 12 -r'                              # Restore
# alias RA='duplicacy restore -ignore-owner -overwrite -delete -threads 12 -r'          # Restore all
# alias BP='duplicacy prune -threads 12 -keep 360:360 -keep 30:180 -keep 7:30 -keep 1:7' # Prune

# Sync
alias R="rclone -PL sync --exclude-from ~/.rclone-exclude.lst"
alias smc='rclone -PL sync --exclude-from ~/.rclone-exclude.lst ~/Archive/Music/ "box:Debajit/Music/" -n'
alias smn='rsync -aPvhsL --exclude-from ~/.rsync-exclude.lst ~/Archive/Music/ "nas:/volume2/Music/" -ni | less'

# ls
alias ls='exa --group-directories-first'
alias la='exa -lga'              # Show all files, including dotfiles
alias ll='exa -lg'               # Show long listing
alias lk='exa -lg --sort size'   # Long listing by size, largest size at the bottom
alias lt='exa -lg --sort newest' # Lists sorted by date, most recent last

# Development
alias ys='yarn start'
alias rp='bundle gem --mit --test rspec'  # Ruby project

# File information
alias ext="fd -t f | grep -oE '\.(\w+)$' | sort | uniq -c | sort -nr"   # Print extensions of all files with counts
alias extl="fd -t l | grep -oE '\.(\w+)$' | sort | uniq -c | sort -nr"  # Print extensions of all symlinks with counts

# Navigation.
# Directory jumping. “1” to jump to the last dir and so on.
# alias j='dirs -v'               # List recent dirs to jump to them quickly
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# Security
alias en='gpg --symmetric --cipher-algo AES256' # Encrypt

# Shell
alias Z='source "${HOME}/.zshrc"' # Reload ZSH configuration

# SSH
alias sshg="ssh-keygen -t ed25519"
alias ssha="ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_ed25519_APP -C ${USER}_APP@${HOSTNAME}"
alias ssh-fingerprint-md5='ssh-keygen -l -E md5 -f'
alias ssh-fingerprint-sha='ssh-keygen -lf'

# Useful utility aliases
alias isp='curl ifconfig.co/json | jq .asn_org' # Show your ISP (experimental)
alias start-web-server='python3 -m http.server' # Start a web server from current dir. Port optional: `start-web-server 1111`

# YouTube
yt() { mpv --ytdl-format="bestvideo[height<=?1080]+bestaudio/best"  ytdl://ytsearch:"$*" }                           # YouTube video
yta() { mpv --ytdl-format=bestaudio ytdl://ytsearch:"$*" }  # YouTube audio

# Aliases with OS-specific implementations
# See OS detection in https://stackoverflow.com/a/18434831/2288585
case "$OSTYPE" in
  # GNU/Linux
  linux*)
    #-------------------------------------
    # Keyboard customizations
    #-------------------------------------

    # Keyboard defaults. A basic keyboard map override for GNOME with
    # the following remappings: (See also
    # https://unix.stackexchange.com/a/333392)
    #
    # - Caps lock → Control
    # - Right Alt → Compose
    #
    alias kd="dconf write /org/gnome/desktop/input-sources/xkb-options \"['terminate:ctrl_alt_bksp', 'caps:ctrl_modifier', 'compose:ralt']\""

    # KeYboard: Swap Super and Meta. This is convenient for hardware
    # like the Framework Laptop, to have Super under your left thumb.
    alias ks="dconf write /org/gnome/desktop/input-sources/xkb-options \"['terminate:ctrl_alt_bksp', 'caps:ctrl_modifier', 'compose:ralt', 'altwin:swap_lalt_lwin']\""

    # Custom command overrides
    alias df="df -Thx squashfs" # Exclude snaps. See https://askubuntu.com/a/1337531
    alias open="xdg-open"

    # Package management
    distro=$(grep -ioP '^ID=\K.+' /etc/os-release 2> /dev/null) # See https://unix.stackexchange.com/a/671133

    case "${distro}" in
      arch)
        # Package management
        alias pi='sudo pacman -S'           # Package install
        alias pq='pacman -Ss'               # Package query/search in Arch repo
        alias pr='sudo pacman -Rs'          # Package remove. See https://wiki.archlinux.org/title/pacman
        alias pu='sudo pacman -Syu && paru && flatpak update' # Package update (all from Arch repo)
        alias pp='pacman -Sii'              # Package info
        alias pf='pacman -F'                # Package that provides a binary or file
        alias pw='pactree -r'               # Which top-level package depends on this package?

        alias pl='pacman -Qs'               # Package local. Search for a locally installed package
        alias po='pacman -Qtdq'             # Package orphans (installed as deps but not required by any package)
        alias pc='pacman -Qtdq | sudo pacman -Rns -' # Package cleanup unused packages

        # Audio (PipeWire. See https://wiki.archlinux.org/title/PipeWire)
        alias ao='pactl list sinks short | column -t'                                 # Audio output
        alias ap='pactl set-default-sink raop_sink.Bose-SoundTouch-20.local.ipv4'     # Airplay
        alias al='pactl set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo'  # Use local audio output
        alias ar='systemctl --user restart pipewire'                                  # Restart PipeWire user service
        ;;

      manjaro)
        # Package management
        alias pi="pamac install"            # Package install
        alias pr="pamac remove"             # Package remove/uninstall
        alias pq="pamac search"             # Package query/search/info
        alias pp="pamac info"               # Package info
        alias pcu='pamac checkupdates -a'   # Package check for updates (all packages including AUR)
        alias pu='pamac upgrade -a'         # Package update (all packages including AUR)
        alias pw='pactree -r'               # Which top-level package depends on this package?

        # Audio (PulseAudio. See https://wiki.archlinux.org/title/PulseAudio/Examples )
        alias ao="pacmd list-sinks | grep -e 'name:' -e 'index:'"                     # Audio output
        alias ap='pactl set-default-sink raop_output.Bose-SoundTouch-20.local'        # Airplay
        alias al='pactl set-default-sink alsa_output.pci-0000_00_1b.0.analog-stereo'  # Use local audio output
        alias ar='systemctl --user restart pulseaudio'                                # Restart PulseAudio user service
        ;;

      ubuntu)
        # Package management
	alias pq='apt search'                                   # Package search
	alias pi='sudo apt install'                             # Package install
        alias pcu='sudo apt update && apt list --upgradable'    # Package check for updates
        alias pu='sudo apt upgrade'                             # Package upgrade (all)
        alias pc='sudo apt autoremove'                          # Package cleanup unused packages
	alias pr='sudo apt remove'                              # Package remove
        ;;
    esac

    # Synology GNU/Linux
    if [[ -d /usr/syno ]]; then
      # Package management (Entware/opkg). See also https://github.com/Entware/Entware/wiki#using-repo
      alias pi='sudo opkg install'
      alias pq='sudo opkg find'             # Provide a quoted regex for more complex queries
      alias pr='sudo opkg remove'
      alias pu='sudo opkg upgrade'
      alias pp='sudo opkg info'
    fi
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