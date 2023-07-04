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

# See https://stackoverflow.com/a/53083343
SOURCE_FILES = $(shell git ls-files ':!:Makefile' ':!:LICENSE' ':!:README.md')
INSTALL_DIR = ${HOME}
TARGET_FILES = $(addprefix $(INSTALL_DIR)/, $(SOURCE_FILES))

# Install all files using GNU Stow
.PHONE: all
all:
	stow -vRt ~ */

# See “Static Pattern Rules”
# https://www.gnu.org/software/make/manual/make.html#Rule-Example
$(TARGET_FILES): $(INSTALL_DIR)/%: %
	cp $< $@

.PHONY: uninstall
uninstall:
	rm -f $(TARGET_FILES)
