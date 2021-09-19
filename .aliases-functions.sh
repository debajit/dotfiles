# Open the given file or dir. Without any args, opens the current dir.
o() { open "${1:-.}" }

# Tree-like file listing
t() { tree -C "${1:-.}" | less -R }
tt() { tree -C -L 2 "${1:-.}" | less -R }

# Detect the volume level in the given audio file. Look at the
# max_volume value here. If you increase the volume level of this
# audio file, this max_volume value will change.
#
# USAGE
#   volumedetect AUDIO_FILE_NAME
#
volumedetect() { ffmpeg -i "${1}" -filter:a volumedetect -f null /dev/null }
