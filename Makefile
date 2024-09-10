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

# Install all files using GNU Stow
.PHONY: all
all:
	stow -vRt ~ */

# .PHONY: zsh
# $(ZSH_TARGET_FILES): ${HOME}/%: $(ZSH_SOURCE_FILES)
#	@echo $


# # See “Static Pattern Rules”
# # https://www.gnu.org/software/make/manual/make.html#Rule-Example
# $(TARGET_FILES): $(INSTALL_DIR)/%: %
#	cp $< $@

# .PHONY: uninstall
# uninstall:
#	rm -f $(TARGET_FILES)
