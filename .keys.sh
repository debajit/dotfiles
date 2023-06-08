# Shell operations
bindkey -s '^[R' 'source ~/.zshrc\n'                       # Alt+Shift+r => Reload zsh configuration

# Single-key shortcuts. (Ensure that these do not conflict with the
# shell’s Emacs-style Meta keybindings you care about).
bindkey -s '^[l' 'lt\n'                                    # Alt+l => ls
bindkey -s '^[u' 'cd ..\n'                                 # Alt+u => cd ..
bindkey -s '^[-' 'cd -\n'                                  # Alt+- => cd -    (Previous directory)
if (( $+commands[zoxide] )); then
  bindkey -s '^[j' 'zi\n'                                  # Alt+j => zi (zoxide recent directory picker)
else
  bindkey -s '^[j' 'dirs -v\n'                             # Alt+j => dirs -v (if zoxide is not installed)
fi

# Text insertion
bindkey -s '^[C' 'cd '                                     # Alt+Shift+c => Insert text: “cd ”
bindkey -s '^[D' 'cd ~/Downloads\n'                        # Alt+Shift+d => cd ~/Downloads
bindkey -s '^[G' ' | rg -S '                               # Alt+Shift+g => | rg -S     (grep with smart-case)
bindkey -s '^[L' ' | less '                                # Alt+Shift+l => | less      (page)

# Jump to directory
bindkey -s '^[H' 'cd\n'                                    # Alt+Shift+h => cd
bindkey -s '^[T' 'cd /tmp\n'                               # Alt+Shift+t => cd /tmp
bindkey -s '^[W' 'cd ~/Projects/Code/debajit.com-hugo/\n'  # Alt+Shift+w => Website

# Commands
bindkey -s '^[B' 'backup'                                  # Alt+Shift+b => backup
bindkey -s '^[S' 'espanso restart\n'                       # Alt+Shift+s => espanso restart
bindkey -s '^[^L' 'git-log-fzf\n'                          # Ctrl+Alt+l  => git commit browser (with fzf)
bindkey -s '^[N^[M' 'rsync -aPvhsL --exclude-from ~/.rsync-exclude.lst ~/Archive/Music/ "nas:/volume2/Music/" -ni'       # Alt+Shift+nm => Sync music to nas
bindkey -s '^[^N^[^M' 'rclone -PL sync --exclude-from ~/.rclone-exclude.lst ~/Archive/Music/ "box:Debajit/Music/" -n'    # Ctrl+Alt+nm  => Sync music to cloud
bindkey -s '^[N^[P' 'rsync -aPvhsL --exclude-from ~/.rsync-exclude.lst ~/Archive/Pictures/ "nas:/volume2/Pictures/" -ni' # Alt+Shift+np => Sync pictures to nas
