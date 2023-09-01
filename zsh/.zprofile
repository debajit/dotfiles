# Ruby Gems. See https://wiki.archlinux.org/title/Ruby#Setup
if (( $+commands[ruby] )); then
if command -v ruby &> /dev/null; then
  export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
  export PATH="$PATH:$GEM_HOME/bin"
fi

# Personal scripts and binaries
for dir in "${HOME}/.local/bin" "${HOME}/bin"; do
  [[ -d "${dir}" ]] && export PATH="${PATH}:${dir}"
done

# keychain --nogui id_ed25519
