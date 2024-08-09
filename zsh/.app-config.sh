#
# fzf.
# See https://wiki.archlinux.org/index.php/Fzf
#
case "$OSTYPE" in
  # Linux
  linux*)
    source_file /usr/share/fzf/key-bindings.zsh # Arch-based distros
    source_file /usr/share/fzf/completion.zsh   # Arch-based distros
    source_file "${HOME}/.fzf.zsh"              # Other
    ;;

  # macOS
  darwin*)
    source_dotfile ".fzf.zsh"
    ;;
esac

# # Rose Pine theme for fzf
# # https://github.com/rose-pine/fzf/blob/main/dist/rose-pine.sh
# export FZF_DEFAULT_OPTS="
#     --color=fg:#908caa,bg:#191724,hl:#ebbcba
#     --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
#     --color=border:#403d52,header:#31748f,gutter:#191724
#     --color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
#     --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

# Rose Pine Moon theme for fzf.
# https://github.com/rose-pine/fzf/blob/main/dist/rose-pine-moon.sh
export FZF_DEFAULT_OPTS="
    --color=fg:#908caa,bg:#232136,hl:#ea9a97
    --color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
    --color=border:#44415a,header:#3e8fb0,gutter:#232136
    --color=spinner:#f6c177,info:#9ccfd8,separator:#44415a
    --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"


# Yazi
# See https://yazi-rs.github.io/docs/quick-start

function f() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}


#
# zoxide
# Directory autojump based on frecency.
#
# See https://github.com/ajeetdsouza/zoxide
#
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# AWS CLI
source_file /usr/local/aws/bin/aws_zsh_completer.sh

# Python
# See https://medium.com/analytics-vidhya/setting-up-python-environment-in-macos-using-pyenv-and-pipenv-116293da8e72
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
