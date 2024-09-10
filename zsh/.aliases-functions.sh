# Open the given file or dir. Without any args, opens the current dir.
o() { open "${1:-.}" }

# Tree-like file listing
t() { tree -C "${1:-.}" | less -R }
tt() { tree -C -L 2 "${1:-.}" | less -R }

# Detect the volume level in the given audio file. Look at the
# max_volume value here. If you increase the volume level of this
# audio file, this max_volume value will change.
#
# USAGE
#   volumedetect AUDIO_FILE_NAME
#
volumedetect() { ffmpeg -i "${1}" -filter:a volumedetect -f null /dev/null }

#-----------------------------------------------------------------------
# Git utility functions.
# Written by Hitoshi Uchida
# https://cocktailmake.github.io/posts/improvement-of-git-commands-with-fzf/
#-----------------------------------------------------------------------

is_in_git_repo() {
    # git rev-parse HEAD > /dev/null 2>&1
    git rev-parse HEAD > /dev/null
}

# Git log browser
git-log-fzf() { # fshow - git commit browser
    is_in_git_repo || return

    _gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
    _viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always %'"
    git log --graph --color=always \
    --format="%C(auto)%h%d [%an] %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
    --preview="$_viewGitLogLine" \
    --bind "ctrl-m:execute:
        (grep -o '[a-f0-9]\{7\}' | head -1 |
        xargs -I % sh -c 'git show --no-abbrev-commit %') << 'FZF-EOF'
        {}
FZF-EOF"
}

# Filter branches.
git-br-fzf() {
    is_in_git_repo || return

    local tags branches target
    tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
    branches=$(
    git branch --all | grep -v HEAD |
        sed "s/.* //" | sed "s#remotes/[^/]*/##" |
        sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
    target=$(
    (echo "$tags"; echo "$branches") |
        fzf --no-hscroll --no-multi --delimiter="\t" -n 2 \
        --ansi --preview="git log -200 --pretty=format:%s $(echo {+2..} |  sed 's/$/../' )" ) || return
    echo $(echo "$target" | awk -F "\t" '{print $2}')
}

# Filter branches and checkout the selected one with <enter> key,
git-co-fzf() {
    is_in_git_repo || return
    git checkout $(git-br-fzf)
}
