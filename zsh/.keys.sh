setopt nullglob

# Shell operations
bindkey -s '^[R' 'source ~/.zshrc\n'       # Alt+Shift+r => Reload zsh configuration

# Core/frequently-used shortcuts. (Ensure that these do not conflict
# with the shell’s Emacs-style Meta keybindings you care about).

# Alt+o => Open polymorphically
function _open_polymorphically() {
  media_files=(*(.mkv|.flac|.mp4|.m4a)(.om))

  # Run Hugo and open browser
  if [[ -f "./config/_default/hugo.yaml" ]]; then
    gum spin --spinner points --title "Starting Hugo server..." -- xdg-open "http://localhost:1313" && hugo server -D --cleanDestinationDir

  # Run JS project
  elif [[ -f "./package-lock.json" ]]; then
    BUFFER='npm start'
    zle accept-line

  # Run Makefile
  elif [[ -f "Makefile" ]]; then
    BUFFER='make -k'
    zle accept-line

  # Open media files
  elif [[ -e "${media_files[1]}" ]]; then
    BUFFER="mpv --hwdec=auto \"${media_files[1]}\""
    zle accept-line
  fi
}
zle -N _open_polymorphically
bindkey '^[o' _open_polymorphically
# Alt+b => Open latest text file in dir (cycles through bat -> o -> less)
function _open_latest_text_file() {
  _latest_text_files=(*(.csv|.txt|.md|.org|.py)(.om))

  if [[ -e "${_latest_text_files[1]}" ]]; then
    if [[ -z "${BUFFER}" || "${BUFFER:0:5}" == "less " ]]; then
      BUFFER="bat \"${_latest_text_files[1]}\""
      zle end-of-line
    elif [[ "${BUFFER:0:4}" == "bat " ]]; then
      BUFFER="o \"${_latest_text_files[1]}\""
      zle end-of-line
    elif [[ "${BUFFER:0:2}" == "o " ]]; then
      BUFFER="less \"${_latest_text_files[1]}\""
      zle end-of-line
    fi
  fi
}
zle -N _open_latest_text_file
bindkey '^[b' _open_latest_text_file

# Alt+l => ‘ls’ (if command line empty) or
#          ‘| less’ if a command was already typed
function _ls_or_pipe_less() {
  if [[ -z "$BUFFER" ]]; then
    BUFFER="lt"
    zle accept-line
  else
    if [[ ${BUFFER: -1} != ' ' ]]; then # If the rightmost character is not a space
      BUFFER+=' '
    fi

    BUFFER+="| less "
    zle end-of-line
  fi
}
zle -N _ls_or_pipe_less
bindkey '^[l' _ls_or_pipe_less

# Alt+g => Toggle between ‘rg -S’ and ‘git g’ (if command is empty) or
#          ‘| rg’ if a command has already been typed
function _rg_or_pipe_grep() {
  if [[ -z "$BUFFER" ]]; then
    BUFFER="rg -S "
    zle end-of-line
  else
    if [[ "${BUFFER}" == "rg -S " ]]; then
      BUFFER="git g "
    elif [[ "${BUFFER}" == "git g " ]]; then
      BUFFER="rg -S "
    else
      if [[ ${BUFFER: -1} != ' ' ]]; then # If the rightmost character is not a space
        BUFFER+=' '
      fi

      BUFFER+="| rg -S "
      zle end-of-line
    fi
  fi
}
zle -N _rg_or_pipe_grep
bindkey '^[g' _rg_or_pipe_grep

# Alt+e => Toggle between ‘echo "${?}"’ and ‘echo’ (if command is empty) or
function _echo() {
  echo_var_command='echo "${?}"'
  echo_command='echo '

  if [[ -z "${BUFFER}" || "${BUFFER}" == "${echo_command}" ]]; then
    BUFFER="${echo_var_command}"
    zle end-of-line
    ((CURSOR-=2))
  elif [[ "${BUFFER}" == "${echo_var_command}" ]]; then
    BUFFER="${echo_command}"
    zle end-of-line
  fi
}
zle -N _echo
bindkey '^[e' _echo

# Alt+z => Unzip latest zip file (or similar)
function _unzip_latest_zip_file() {
  zip_files=(*(.zip|.xz|.gz|.rar)(.om))

  if [[ -r "${zip_files[1]}" ]]; then
    BUFFER="aunpack \"${zip_files[1]}\""
    zle end-of-line
  fi
}
zle -N _unzip_latest_zip_file
bindkey '^[z' _unzip_latest_zip_file

bindkey -s '^[L' 'tree -dC\n'              # Alt+Shift+l => Show directories only
bindkey -s '^[u' 'cd ..\n'                 # Alt+u => cd ..
bindkey -s '^[U' 'uname -a\n'              # Alt+Shift+u => uname -a
bindkey -s '^[-' 'cd -\n'                  # Alt+- => cd -    (Previous directory)
bindkey -s '^[E' 'echo $'                  # Alt+e => echo $

# Sudo
bindkey -s '^[[112;13u' 'sudo $(fc -ln -1)' # Super+Control+p => sudo previous command. See https://askubuntu.com/a/530687/1655230

# Development related
bindkey -s '^[[114;9u'  'run-app\n'          # Super+r       => Run this program or start the server (polymorphically)
bindkey -s '^[[108;9u'  'git ll\n'           # Super+l       => git ll
bindkey -s '^[[108;10u' 'git-log-fzf\n'      # Super+Shift+l => git-log-fzf (commit browser with fuzzy find)
bindkey -s '^[[115;9u'  'git s\n'            # Super+s       => git status
bindkey -s '^[[115;10u' 'git show\n'         # Super+Shift+s => git show
bindkey -s '^[[100;9u'  'git diff\n'         # Super+d       => git diff
bindkey -s '^[[98;9u'   'git branch -avv\n'  # Super+b      => git branch -avv

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
bindkey -s '^[G' ' | rg -S '               # Alt+Shift+g => | rg -S               (grep with smart-case)
bindkey -s '^[J' ' | jq -C | less -R'      # Alt+Shift+j => | jq -C | less -$     (jq colored and paginated)

# Jump to directory
bindkey -s '^[C' 'cd ~/Projects/Setup/dotfiles\n'          # Alt+Shift+c => dotfiles (configuration)
bindkey -s '^[H' 'cd\n'                                    # Alt+Shift+h => cd
bindkey -s '^[T' 'cd /tmp\n'                               # Alt+Shift+t => cd /tmp
bindkey -s '^[W' 'cd ~/Projects/Code/debajit.com-hugo/\n'  # Alt+Shift+w => Website
bindkey -s '^[P' 'cd ~/Archive/Pictures/Photography/\n'    # Alt+Shift+p => Photography

# Wait for a process to finish, and then maybe start another
bindkey -s '^[w^[a' 'tail -f /dev/null --pid=$(pgrep -o aria2c) && aria2c '  # M-w M-a => Wait for aria2c
bindkey -s '^[w^[r' 'tail -f /dev/null --pid=$(pgrep -o rsync) && rsync '    # M-w M-r => Wait for rsync
bindkey -s '^[w^[m' 'tail -f /dev/null --pid=$(pgrep -o mpv) && mpv '        # M-w M-m => Wait for mpv
bindkey -s '^[w^[y' 'tail -f /dev/null --pid=$(pgrep -o mpv) && yta '        # M-w M-y => Wait for yta (CLI YouTube audio streaming)

# Commands
bindkey -s '^[B' 'backup'                                  # Alt+Shift+b => backup
bindkey -s '^[S' 'espanso restart\n'                       # Alt+Shift+s => espanso restart

# Sync
bindkey -s '^[s^[m' 'rsync -aPvhsL --exclude-from ~/.rsync-exclude.lst ~/Archive/Music/ "nas:/volume2/Music/" -ni'         # M-s M-m      => Sync music to nas
bindkey -s '^[S^[M' 'rclone -PL sync --exclude-from ~/.rclone-exclude.lst ~/Archive/Music/ "box:Debajit/Music/" -n'        # M-S-s M-S-m  => Sync music to cloud
bindkey -s '^[[115;13u^[[109;13u' 'time rsync -avhsWL --progress --no-perms --no-owner --no-group --exclude-from ~/.rsync-exclude.lst ~/Archive/Music/ ~/Mounts/Flacbox/Music/ --delete -ni'  # C-s-s C-s-m  => Sync music to phone (via USB cable)

bindkey -s '^[s^[p' 'rsync -aPvhsL --exclude-from ~/.rsync-exclude.lst ~/Archive/Pictures/ "nas:/volume2/Pictures/" -ni' # M-s M-p      => Sync pictures to nas

# Logs
bindkey -s '^[J^[A' 'journalctl -eu pipewire --user'  # M-J M-A (all-caps) =>  Journal for audio server
bindkey -s '^[J^[C' 'journalctl -b -1 -eu cronie'     # M-J M-C (all-caps) =>  Journal for cron

# ssh
bindkey -s '^[s^[n' 'ssh nas\n'              # M-s, M-n => ssh nas
bindkey -s '^[s^[s' 'ssh tty.sdf.org\n'      # M-s, M-s => ssh tty.sdf.org
bindkey -s '^[s^[t' 'ssh tilde.institute\n'  # M-s, M-s => ssh tilde.institute
