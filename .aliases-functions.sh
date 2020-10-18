# Detect the volume level in the given audio file. Look at the
# max_volume value here. If you increase the volume level of this
# audio file, this max_volume value will change.
volumedetect() { ffmpeg -i "${1}" -filter:a volumedetect -f null /dev/null }
