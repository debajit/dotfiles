# Ruby Gems. See https://wiki.archlinux.org/title/Ruby#Setup
if (( $+commands[ruby] )); then
  export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
  export PATH="$PATH:$GEM_HOME/bin"
fi

# Personal scripts and binaries
for dir in "${HOME}/.local/bin" "${HOME}/bin"; do
  [[ -d "${dir}" ]] && export PATH="${PATH}:${dir}"
done

# Brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# sdkman
export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

# PKI cert bundle for talking to Substrate endpoints
export REQUESTS_CA_BUNDLE="${HOME}/.oci/tls-ca-bundle.pem"
