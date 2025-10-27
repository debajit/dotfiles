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

.PHONY: all paru

# Install all files using GNU Stow
all:
	stow -vRt ~ */

# Install paru
paru:
	time ./scripts/install-paru "$(PARU_DIR)"

# .PHONY: uninstall
# uninstall:
#	rm -f $(TARGET_FILES)
