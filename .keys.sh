# Shell operations
bindkey -s '^[R' 'source ~/.zshrc\n'                       # Alt+Shift+r  =>  Reload zsh configuration

# Navigating between directories
bindkey -s '^[U' 'cd ..\n'                                 # Alt+Shift+u  =>  cd ..
bindkey -s '^[_' 'cd -\n'                                  # Alt+Shift+-  =>  cd -    (Previous directory)

# Text insertion
bindkey -s '^[C' 'cd '                                     # Alt+Shift+c  =>  Insert text: “cd ”
bindkey -s '^[D' '~/.'                                     # Alt+Shift+d  =>  Insert text: “~/.”
bindkey -s '^[G' ' | rg -S '                               # Alt+Shift+g  =>  | rg -S     (grep with smart-case)
bindkey -s '^[L' ' | less '                                # Alt+Shift+l  =>  | less      (page)

# Jump to directory
bindkey -s '^[H' 'cd\n'                                    # Alt+Shift+h  =>  cd
bindkey -s '^[T' 'cd /tmp\n'                               # Alt+Shift+t  =>  cd /tmp
bindkey -s '^[W' 'cd ~/Projects/Code/debajit.com-hugo/\n'  # Alt+Shift+w  =>  Website
bindkey -s '^[J' 'zi\n'                                    # Alt+Shift+j  =>  zi          (zoxide directory picker)

# Programs
bindkey -s '^[B' 'backup'                                  # Alt+Shift+b  =>  backup
