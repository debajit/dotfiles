#
# Executes commands at the start of an interactive zsh session.
#
# Authors:
#   Debajit Adhikary <debajit@debajit.com>
#

# Sources the given file, if it exists.
function source_file() {
    filename="${1}"
    [[ -f ${filename} ]] && source "${filename}"
}

# Sources the given dotfile from the home directory, if the dotfile exists.
function source_dotfile() {
    filename="$HOME/${1}"
    source_file "${filename}"
}

source_dotfile ".zsh-config"       # My custom ZSH configuration
source_dotfile ".zshrc.local"      # Local config (e.g. workplace-specific)

# Prompt
# eval "$(starship init zsh)"        # Uncomment this line to enable Starship. I find it be slow on older machines, so I wrote my own prompt (next line)
source_dotfile ".zsh-prompt"

source_dotfile ".aliases"                          # General aliases, overridable locally
source_dotfile ".aliases-global"                   # Global aliases like L, G
source_dotfile ".aliases-suffix"                   # Associate file ext with default program
source_dotfile ".aliases-functions.sh"             # Functions
source_dotfile ".aliases-radio.sh"                 # Play radio from the command line
source_dotfile ".aliases.private.sh"               # Private aliases
source_dotfile ".aliases.local"                    # Local aliases
source_dotfile ".paths"                            # Global path settings
source_dotfile ".paths.local"                      # Global path settings
source_dotfile ".env_vars"                         # Environment variables
source_dotfile ".env_vars.local"                   # Environment variables
source_dotfile ".env_vars.secret"                  # Secret environment variables
source_dotfile '.app-config.sh'
source_dotfile ".nix-profile/etc/profile.d/nix.sh" # Setup nix
