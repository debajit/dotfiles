# Ruby Gems. See https://wiki.archlinux.org/title/Ruby#Setup
if command -v ruby &> /dev/null; then
  export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
  export PATH="$PATH:$GEM_HOME/bin"
fi

# keychain --nogui id_ed25519
