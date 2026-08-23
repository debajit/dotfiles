#!/usr/bin/env bash
#
# Claude Code status line, inspired by ~/.zsh-prompt.sh
#
# Colors (TrueColor ANSI, matching the zsh prompt):
#   Cyan    #5efcfc  -> directory
#   Gold    #f6c177  -> git branch
#   Blue    #43a0bc  -> model name
#   Reset            -> \033[0m
#   Bold             -> \033[1m

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Shorten path to last 5 components (mirrors zsh %5~)
shortened_path() {
  local path="$1"
  # Replace $HOME with ~
  path="${path/#$HOME/\~}"
  # Keep at most 5 path components
  local IFS='/'
  read -ra parts <<< "$path"
  local count="${#parts[@]}"
  if [ "$count" -le 5 ]; then
    echo "$path"
  else
    local result=""
    for ((i=count-5; i<count; i++)); do
      if [ -z "$result" ]; then
        result="${parts[$i]}"
      else
        result="$result/${parts[$i]}"
      fi
    done
    echo ".../$result"
  fi
}

short_path=$(shortened_path "$cwd")

# Git branch (mirrors vcs_info; skips optional locks to avoid blocking)
git_branch=""
if git_out=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null); then
  git_branch="$git_out"
elif git_out=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null); then
  git_branch="$git_out"
fi

# Context usage indicator
ctx_str=""
if [ -n "$used_pct" ]; then
  used_int=${used_pct%.*}
  ctx_str=" · ctx ${used_int}%"
fi

# ANSI color codes
CYAN='\033[38;2;94;252;252m'
GOLD='\033[38;2;246;193;119m'
BLUE='\033[38;2;67;160;188m'
RESET='\033[0m'
BOLD='\033[1m'

# Directory segment
printf "${BOLD}${CYAN}%s${RESET}" "$short_path"

# Git branch segment
if [ -n "$git_branch" ]; then
  printf " ${BOLD}${GOLD}📸 %s${RESET}" "$git_branch"
fi

# Model + context segment
if [ -n "$model" ]; then
  printf " ${BLUE}· %s%s${RESET}" "$model" "$ctx_str"
fi
