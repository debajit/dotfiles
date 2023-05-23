#
# .zsh-prompt
#
# My ZSH prompt.
#
# References:
# - https://arjanvandergaag.nl/blog/customize-zsh-prompt-with-vcs-info.html
# - https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/
# - http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
# - 256 colors: https://askubuntu.com/a/821163
#

# Enable git support. See
# - https://stackoverflow.com/a/30840986/2288585
# - man zshbuiltins
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
setopt prompt_subst

# Enable colors
autoload -U colors && colors

precmd() {
  vcs_info
}

# Format the vcs_info_msg_0_ variable
# Format the vcs_info_msg_0_ variable
# zstyle ':vcs_info:git:*' formats '🌱 %b'
# zstyle ':vcs_info:git:*' formats '🍄 %b'
# zstyle ':vcs_info:git:*' formats '🐙 %b'
zstyle ':vcs_info:git:*' formats '🎃 %b'
# zstyle ':vcs_info:git:*' formats '👻 %b'


# Basic prompts:
# export PROMPT='%5~ %# '
# export PROMPT='%B%5~❯%b '

NEWLINE=$'\n'
# See color code previews here: https://i.stack.imgur.com/Vn0V3.png

# Default prompt
export PROMPT='${NEWLINE}%B%F{87}%5~%f%B%F{187} ${vcs_info_msg_0_}%f%b${NEWLINE}%B%F{154}%(!.#.❯) %f%b'

# Use extended prompt for remote sessions
if [[ -n "$SESSION_TYPE" ]]; then
  # Long prompt: "user at host in dir :emoji: branch"
  export PROMPT='${NEWLINE}%F{183}%n%f %F{250}at%f %F{215}%m%f %F{250}in%f %B%F{87}%5~%f%B%F{187} ${vcs_info_msg_0_}%f%b${NEWLINE}%B%F{154}%(!.#.❯) %f%b'
fi
