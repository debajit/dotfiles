#
# Makefile
#
# Copies all the dotfiles in this directory to $HOME.
#
# USAGE:
#
#   INSTALLATION. Either of the following will work:
#     make
#     make -j     # Run in parallel
#     make install
#
#   UNINSTALLATION:
#     make uninstall
#

# See https://stackoverflow.com/a/53083343
SOURCE_FILES = $(shell  git ls-files -- ':!:Makefile')
INSTALL_DIR = ${HOME}
TARGET_FILES = $(addprefix $(INSTALL_DIR)/, $(SOURCE_FILES))

.PHONY: install
install: $(TARGET_FILES)

# See “Static Pattern Rules”
# https://www.gnu.org/software/make/manual/make.html#Rule-Example
$(TARGET_FILES): $(INSTALL_DIR)/%: %
	cp $< $@

.PHONY: uninstall
uninstall:
	rm -f $(TARGET_FILES)
