#
# .zsh-config
# Configure zsh options.
#
# - See supported options: setopt
# - See details about each option: man zshoptions
# - http://zsh.sourceforge.net/Intro/intro_16.html#SEC16
# - https://scriptingosx.com/2019/06/moving-to-zsh-part-3-shell-options/
#

# Use Emacs keybindings. See
# http://zsh.sourceforge.net/Guide/zshguide04.html
bindkey -e

#----------------------------------------
# Completion
#----------------------------------------

# Initialize completion system
autoload -Uz compinit
compinit

# Autocomplete the following with Tab:
# - aliases
# - words from history
#
# See
# - https://superuser.com/a/1514591/2041
# - man zshcompsys
#
zstyle ':completion:*' completer _expand_alias _complete _history _approximate

# Tab-autocompletion will match lowercase letters for uppercase.
# "cd desk<TAB>" will complete to "cd Desktop"
# See https://superuser.com/a/1092328/2041
#
# Also, allow autocomplete from the middle of the filename
# See https://stackoverflow.com/a/22627273/2288585
#
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' '+l:|=* r:|=*'

# Show menu when there are several completions to choose from
zstyle ':completion:*' menu select

# Better SSH/Rsync/SCP Autocomplete
# Adapted from https://www.codyhiar.com/blog/zsh-autocomplete-with-ssh-config-file/
zstyle ':completion:*:(scp|rsync|kitty +kitten ssh):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(ssh|scp|rsync|kitty +kitten ssh):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync|kitty +kitten ssh):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Bind Shift+Tab for the previous completion (e.g. in a menu selection)
# See https://unix.stackexchange.com/a/84869/141850
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete

#-----------------------------------------------------------------------
# History.
#-----------------------------------------------------------------------
# See
# - https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/history.zsh
# - https://nuclearsquid.com/writings/shared-history-in-zsh/
# - https://scriptingosx.com/2019/06/moving-to-zsh-part-3-shell-options/
#-----------------------------------------------------------------------

HISTFILE="${HOME}/.zsh-history" # The path to the history file.
HISTSIZE=10000                  # The maximum number of events to save in the internal history.
SAVEHIST=10000                  # The maximum number of events to save in the history file.
setopt hist_ignore_dups         # Do not store duplicate commands
setopt inc_append_history       # Add command to history immediately
setopt share_history            # Share history across zsh sessions


#-----------------------------------------------------------------------
# Text editing
#-----------------------------------------------------------------------

# Delete backwards upto / and other delimiters instead of deleting
# entire paths. See https://superuser.com/a/696932/2041
autoload -Uz select-word-style
select-word-style bash


#-----------------------------------------------------------------------
# Autocorrect. Try to correct the spelling of commands
#-----------------------------------------------------------------------

setopt correct

#-----------------------------------------------------------------------
# Directory navigation
#-----------------------------------------------------------------------

# Type directory name to auto-cd to it
setopt autocd

# Dir stack. See
# - https://unix.stackexchange.com/a/273088/141850
# - http://zsh.sourceforge.net/Doc/Release/Options.html#Changing-Directories
DIRSTACKSIZE=20
setopt auto_pushd               # Push old dir into dirstack
setopt pushd_ignore_dups        # Do not push duplicate dir names

#-----------------------------------------------------------------------
# URL quoting. See
# - https://emacs.ch/@galdor/110016202546305758
#-----------------------------------------------------------------------

autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

#-----------------------------------------------------------------------
# TrueColor fallback
#-----------------------------------------------------------------------

# For terminals without TrueColor (24-bit color, or 10-bit color)
# support, fall back to the nearest color in the 256-color palette.
# (This can happen on older versions of mosh, for instance). See
# https://wiki.archlinux.org/title/zsh#Colors
#
# [[ "$COLORTERM" == (24bit|truecolor) || "${terminfo[colors]}" -eq '16777216' ]] || zmodload zsh/nearcolor
