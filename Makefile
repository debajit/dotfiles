#
# Makefile
#
# Symlinks all the dotfiles in this directory to $HOME.
#
# USAGE:
#
#   INSTALLATION:
#     make
#
#   UNINSTALLATION:
#     make uninstall
#

# # See https://stackoverflow.com/a/53083343
# SOURCE_FILES = $(shell git ls-files ':!:Makefile' ':!:LICENSE' ':!:README.md')
# INSTALL_DIR = ${HOME}
# TARGET_FILES = $(addprefix $(INSTALL_DIR)/, $(SOURCE_FILES))

# ZSH_DIR := zsh
# ZSH_SOURCE_FILES := $(shell find $(ZSH_DIR) -type f)
# ZSH_TARGET_FILES := $(ZSH_SOURCE_FILES:zsh%=${HOME}%)

# # Path where paru will be cloned
# PARU_DIR := $${HOME}/tmp/Software/paru

.PHONY: all reinstall paru

# Install all files using GNU Stow
all:
	stow -vRt ~ */
	mkdir -p ~/.codex && ln -sfn ~/.claude/skills ~/.codex/skills

# Remove existing dotfile symlinks and recreate them from this checkout.
reinstall:
	find "$(HOME)" -maxdepth 1 -type l -lname '*dotfiles*' -print -delete
	find "$(HOME)/.config" "$(HOME)/.local" "$(HOME)/.claude" -maxdepth 5 -type l -lname '*dotfiles*' -print -delete 2>/dev/null || true
	$(MAKE) all

# Install paru
paru:
	time ./scripts/install-paru "$(PARU_DIR)"

# .PHONY: uninstall
# uninstall:
#	rm -f $(TARGET_FILES)
