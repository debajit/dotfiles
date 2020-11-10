# Do a dry rsync and show what changes would be done (if files are
# also deleted on the remote)
#
# Related:
# - rsyncdir
# - rcopydir
#
dry-rsyncdir() {
  rsync -niaz --delete-after "${1}" "${2}" | egrep -v '^\.'
}

# Detect the volume level in the given audio file. Look at the
# max_volume value here. If you increase the volume level of this
# audio file, this max_volume value will change.
volumedetect() { ffmpeg -i "${1}" -filter:a volumedetect -f null /dev/null }
