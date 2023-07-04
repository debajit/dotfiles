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

source_dotfile ".zsh-config.sh"    # My custom ZSH configuration

# Prompt
# eval "$(starship init zsh)"        # Uncomment this line to enable Starship. I find it be slow on older machines, so I wrote my own prompt (next line)
source_dotfile ".zsh-prompt.sh"

source_dotfile ".env_vars.sh"                      # Environment variables
source_dotfile ".env_vars.local.sh"                # Custom environment variables
source_dotfile ".env_vars.secret.sh"               # Secret environment variables
source_dotfile ".aliases.sh"                       # General aliases, overridable locally
source_dotfile ".aliases-global.sh"                # Global aliases like L, G
source_dotfile ".aliases-suffix.sh"                # Associate file ext with default program
source_dotfile ".aliases-functions.sh"             # Functions
source_dotfile ".aliases-radio.sh"                 # Play radio from the command line
source_dotfile ".aliases.private.sh"               # Private aliases
source_dotfile ".aliases.local.sh"                 # Local aliases
source_dotfile ".keys.sh"                          # Key chords and keybindings for various common shell operations
source_dotfile ".paths"                            # Global path settings
source_dotfile ".paths.local"                      # Global path settings
source_dotfile '.app-config.sh'
source_dotfile ".nix-profile/etc/profile.d/nix.sh" # Setup nix
source_dotfile ".zshrc.local.sh"                   # Local config (e.g. workplace-specific)

cal
