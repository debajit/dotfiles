#
# .zsh-prompt
#
# My ZSH prompt. Uses TrueColor.
#
# The prompt is designed to be aesthetically pleasing and effective,
# especially if you use the terminal for extended periods of time. It
# aims to lower the cognitive load at any time by using progressive
# disclosure:
#
# - A simple prompt is rendered by default with the current working
#   directory (without the username and hostname). If you’re logged in
#   to a remote session, then the username and hostname are added
#   automatically.
#
# - The git branch name is only shown if you’re inside a git
#   repository. No git status is shown at any time, as it can be seen
#   easily by pressing a keystroke (see keys.sh, which binds Super+s
#   for this).
#
# - The emoji separator for the git information is easy to customize
#   (seasonally, for instance) by commenting and uncommenting a line
#   in this file.
#
# References:
# - ★ https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
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
zstyle ':vcs_info:git:*' formats '🌱 %b'
# zstyle ':vcs_info:git:*' formats '🍄 %b'
# zstyle ':vcs_info:git:*' formats '🐙 %b'
# zstyle ':vcs_info:git:*' formats '🎃 %b'
# zstyle ':vcs_info:git:*' formats '👻 %b'


# Basic prompts:
# export PROMPT='%5~ %# '
# export PROMPT='%B%5~❯%b '

NEWLINE=$'\n'
# See color code previews here: https://i.stack.imgur.com/Vn0V3.png

# Default prompt
# Syntax documentation: https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
# man zshmisc
export PROMPT='${NEWLINE}%B%F{#5efcfc}%5~%f%B%F{#f6c177} ${vcs_info_msg_0_}%f%b${NEWLINE}%B%F{154}%(!.#.❯) %f%b'
export RPROMPT='%F{#43a0bc}%L%f' # Show shell nesting depth $SHLVL

# Use extended prompt for remote sessions
if [[ -n "$SESSION_TYPE" ]]; then
  # Long prompt: "user at host in dir :emoji: branch"
  export PROMPT='${NEWLINE}%B%F{#43a0bc}%n%f%b %F{#b2afc6}at%f %B%F{#eb6f92}%m%f%b %F{#b2afc6}in%f %B%F{#5efcfc}%5~%f%B%F{#f6c177} ${vcs_info_msg_0_}%f%b${NEWLINE}%B%F{154}%(!.#.❯) %f%b'
fi
