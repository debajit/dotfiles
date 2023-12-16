# Shell operations
bindkey -s '^[R' 'source ~/.zshrc\n'       # Alt+Shift+r => Reload zsh configuration

# Core/frequently-used shortcuts. (Ensure that these do not conflict
# with the shell’s Emacs-style Meta keybindings you care about).
bindkey -s '^[l' 'lt\n'                    # Alt+l => ls
bindkey -s '^[L' 'tree -dC\n'              # Alt+Shift+l => Show directories only
bindkey -s '^[u' 'cd ..\n'                 # Alt+u => cd ..
bindkey -s '^[U' 'uname -a\n'              # Alt+Shift+u => uname -a
bindkey -s '^[-' 'cd -\n'                  # Alt+- => cd -    (Previous directory)
bindkey -s '^[e' 'echo '                   # Alt+e => echo
bindkey -s '^[E' 'echo $'                  # Alt+e => echo $

# Sudo
bindkey -s '^[[112;13u' 'sudo $(fc -ln -1)' # Super+Control+p => sudo previous command. See https://askubuntu.com/a/530687/1655230

# Development related
bindkey -s '^[[114;9u'  'run-app\n'        # Super+r       => Run this program or start the server (polymorphically)
bindkey -s '^[[108;9u'  'git ll\n'         # Super+l       => git ll
bindkey -s '^[[108;10u' 'git-log-fzf\n'    # Super+Shift+l => git-log-fzf (commit browser with fuzzy find)
bindkey -s '^[[115;9u'  'git s\n'          # Super+s       => git status
bindkey -s '^[[100;9u'  'git d\n'          # Super+d       => git diff
bindkey -s '^[[98;9u'   'git branch -avv\n' # Super+b      => git branch -avv

# Docker
bindkey -s '^[[100;10u^[[105;10u' 'docker images\n'      # Super+Shift+d Super+Shift+i => docker images
bindkey -s '^[[100;10u^[[112;10u' 'docker ps\n'          # Super+Shift+d Super+Shift+p  => docker ps

# Docker Compose
bindkey -s '^[[99;10u^[[117;10u' 'docker compose up -d'      # Super+Shift+c Super+Shift+u => docker compose up -d
bindkey -s '^[[99;10u^[[100;10u' 'docker compose down'       # Super+Shift+c Super+Shift+d => docker compose down
bindkey -s '^[[99;10u^[[108;10u' 'docker compose logs\n'     # Super+Shift+c Super+Shift+l => docker compose logs
bindkey -s '^[[99;10u^[[102;10u' 'docker compose logs -f\n'  # Super+Shift+c Super+Shift+f => docker compose logs -f

# Recent directory picker
if (( $+commands[zoxide] )); then
  bindkey -s '^[j' 'zi\n'                  # M-j => zi (zoxide recent directory picker)
  # bindkey -s '^[[112;10u' 'zi\n'           # C-P => zi (zoxide recent directory picker) (to match my Emacs projects keybinding)
else
  bindkey -s '^[j' 'dirs -v\n'             # M-j => dirs -v (if zoxide is not installed)
  bindkey -s '^[[112;10u' 'dirs -v\n'      # C-P => dirs -v
fi

# Text insertion
bindkey -s '^[D' 'cd ~/Downloads\n'        # Alt+Shift+d => cd ~/Downloads
bindkey -s '^[G' ' | rg -S '               # Alt+Shift+g => | rg -S     (grep with smart-case)
bindkey -s '^[L' ' | less '                # Alt+Shift+l => | less      (page)

# Jump to directory
bindkey -s '^[C' 'cd ~/Projects/Setup/dotfiles\n'          # Alt+Shift+c => dotfiles (configuration)
bindkey -s '^[H' 'cd\n'                                    # Alt+Shift+h => cd
bindkey -s '^[T' 'cd /tmp\n'                               # Alt+Shift+t => cd /tmp
bindkey -s '^[W' 'cd ~/Projects/Code/debajit.com-hugo/\n'  # Alt+Shift+w => Website
bindkey -s '^[P' 'cd ~/Archive/Pictures/Photography/\n'    # Alt+Shift+p => Photography

# Wait for a process to finish, and then maybe start another
bindkey -s '^[w^[a' 'tail -f /dev/null --pid=`pgrep aria2c` && aria2c'  # Wait for aria2c
bindkey -s '^[w^[r' 'tail -f /dev/null --pid=`pgrep rsync` && rsync'    # Wait for rsync
bindkey -s '^[w^[y' 'tail -f /dev/null --pid=`pgrep mpv` && yta'        # Wait for yta (CLI YouTube audio streaming)

# Commands
bindkey -s '^[B' 'backup'                                  # Alt+Shift+b => backup
bindkey -s '^[S' 'espanso restart\n'                       # Alt+Shift+s => espanso restart

# Sync
bindkey -s '^[s^[m' 'rsync -aPvhsL --exclude-from ~/.rsync-exclude.lst ~/Archive/Music/ "nas:/volume2/Music/" -ni'         # M-s M-m      => Sync music to nas
bindkey -s '^[S^[M' 'rclone -PL sync --exclude-from ~/.rclone-exclude.lst ~/Archive/Music/ "box:Debajit/Music/" -n'        # M-S-s M-S-m  => Sync music to cloud
bindkey -s '^[[115;13u^[[109;13u' 'time rsync -avhsWL --progress --no-perms --no-owner --no-group --exclude-from ~/.rsync-exclude.lst ~/Archive/Music/ ~/Mounts/Flacbox/Music/ -ni'  # C-s-s C-s-m  => Sync music to phone (via USB cable)

bindkey -s '^[s^[p' 'rsync -aPvhsL --exclude-from ~/.rsync-exclude.lst ~/Archive/Pictures/ "nas:/volume2/Pictures/" -ni' # M-s M-p      => Sync pictures to nas

# Logs
bindkey -s '^[J^[A' 'journalctl -eu pipewire --user'  # M-J M-A (all-caps) =>  Journal for audio server
bindkey -s '^[J^[C' 'journalctl -b -1 -eu cronie'     # M-J M-C (all-caps) =>  Journal for cron

# ssh
bindkey -s '^[s^[n' 'ssh nas\n'              # M-s, M-n => ssh nas
bindkey -s '^[s^[s' 'ssh tty.sdf.org\n'      # M-s, M-s => ssh tty.sdf.org
bindkey -s '^[s^[t' 'ssh tilde.institute\n'  # M-s, M-s => ssh tilde.institute
