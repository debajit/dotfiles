# EDITOR.
#
# Edit files in an existing Emacs GUI window.
#
# --reuse-frame: reuse existing Emacs frame instead of creating a new one.
#         -a '': auto-start server if not running (or start manually:
#                M-x server-start, or add (server-start) to .emacs)
#
export EDITOR="emacsclient --reuse-frame -a ''"

export CXXFLAGS='-std=c++20'
# export MANPAGER="sh -c 'col -bx | bat -l man -p'" # For macOS
export MAILDIR="$HOME/.mail"

# Bat
export BAT_THEME='gruvbox-dark'

# Docker
# export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
# export DOCKER_HOST=unix://$HOME/.rd/docker.sock # Rancher Desktop

# Gum
export GUM_FILTER_INDICATOR='⏺'

# Kitty
#
# Drop the stale startup-notification ID kitty inherits from gnome-shell.
#
# On X11, kitty consumes and clears DESKTOP_STARTUP_ID itself (the
# os.environ.pop() in init_startup_notification_x11()). On Wayland,
# init_startup_notification() returns early before reaching that line, so the
# variable survives and is inherited by every descendant process.
#
# That leaves apps launched from a kitty shell (e.g. via yazi's openers)
# presenting an activation token that is both expired and already consumed --
# its timestamp is fixed at the moment kitty started. Mutter rejects it, denies
# the focus transfer, and the new window opens behind the terminal.
#
# Clearing it means those apps present no token at all, which takes Mutter's
# plain deny path: focus is still withheld, but the window gets flagged
# demands-attention, and the Grand Theft Focus extension turns that into a real
# focus switch.
unset DESKTOP_STARTUP_ID
