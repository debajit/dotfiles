# Open the given file or dir. Without any args, opens the current dir.
o() { open "${1:-.}" }

# Tree-like file listing
t() { tree -C "${1:-.}" | less -R }
tt() { tree -C -L 2 "${1:-.}" | less -R }

# Do a dry rsync and show what changes would be done (if files are
# also deleted on the remote)
#
# Related:
# - backup
# - syncdir
#
drybackup()  { rsync -niaz "${1}" "${2}" | egrep -v '^\.' | less }
drysyncdir() { rsync -niaz --delete-after "${1}" "${2}" --exclude=".*" | egrep -v '^\.' | less }

# Detect the volume level in the given audio file. Look at the
# max_volume value here. If you increase the volume level of this
# audio file, this max_volume value will change.
#
# USAGE
#   volumedetect AUDIO_FILE_NAME
#
volumedetect() { ffmpeg -i "${1}" -filter:a volumedetect -f null /dev/null }
