# Shell operations
bindkey -s '^[R' 'source ~/.zshrc\n'                       # Alt+Shift+r  =>  Reload zsh configuration

# Navigating between directories
bindkey -s '^[U' 'cd ..\n'                                 # Alt+Shift+u  =>  cd ..
bindkey -s '^[_' 'cd -\n'                                  # Alt+Shift+-  =>  cd -    (Previous directory)

# Text insertion
bindkey -s '^[D' '~/.'                                     # Alt+Shift+d  =>  Insert text: “~/.”

# Jump to directory
bindkey -s '^[H' 'cd\n'                                    # Alt+Shift+h  =>  cd
bindkey -s '^[T' 'cd /tmp\n'                               # Alt+Shift+t  =>  cd /tmp
bindkey -s '^[W' 'cd ~/Projects/Code/debajit.com-hugo/\n'  # Alt+Shift+w  =>  Website
