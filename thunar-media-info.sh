#!/bin/sh
#
# Get media information about audio/video files.
#
# * Put this file into your home binary dir: ~/bin/
# * Make it executable: chmod +x
#
#
# Required Software:
# -------------------------
#   * zenity (for gui mode - default)
#   * ffmpeg
#
#
# Thunar Integration
# ------------------------
#
#   Command:      ~/bin/thunar-media-info.sh -f %f -t %n
#   File Pattern: *
#   Appear On:    Audio Files, Video Files
#
#
# Usage:
# -------------------------
#   thunar-media-info.sh -f <filename> [-c] [-w width(int)] [-h height(int)] [-t window-title]
#
#     required:
#      -f    input filename
#
#     optional:
#      -c    no-gui, show console output (zenity not required)
#            default is to show gui
#
#      -w    (gui) width of window (e.g.: -w 800)
#            default is 800
#
#      -h    (gui) height of window (e.g.: -h 240)
#            default is 240
#
#      -t    (gui) window title
#            default is filename
#
# Note:
# -------------------------
#
# Feel free to adjust/improve and commit back to:
#  https://github.com/cytopia/thunar-custom-actions
#


usage() {
	echo "$0 -f <filename> [-c] [-w width(int)] [-h height(int)] [-t window-title]"
	echo
	echo " required:"
	echo "   -f    input filename"
	echo
	echo " optional:"
	echo "   -c    no-gui, show console output (zenity not required)"
	echo "         default is to show gui"
	echo
	echo "   -w    (gui) width of window (e.g.: -w 800)"
	echo "         default is 800"
	echo
	echo "   -h    (gui) height of window (e.g.: -h 240)"
	echo "         default is 240"
	echo
	echo "   -t    (gui) window title"
	echo "         default is filename"
	echo
	exit 1
}


while getopts ":f:cw:h:t:" i; do
	case "${i}" in
		f)
			f=${OPTARG}
			;;
		c)
			c=yes
			;;
		w)
			w=${OPTARG}
			;;
		h)
			h=${OPTARG}
			;;
		t)
			t=${OPTARG}
			;;
		*)
			echo "Error - unrecognized option $1" 1>&2;
			usage
			;;
	esac
done
shift $((OPTIND-1))

# Check if file is specified
if [ -z "${f}" ]; then
	echo "Error - no file specified" 1>&2;
	usage
fi

# Check if zenity exists
if ! command -v zenity >/dev/null 2>&1 ; then
	echo "Error - 'zenity' not found." 1>&2
	exit 1
fi

# Check if zenity exists
if ! command -v ffmpeg >/dev/null 2>&1 ; then
	echo "Error - 'ffmpeg' not found." 1>&2
	exit 1
fi


########################## console output ###############################

# Do we have textbased output?
if [ -n "${c}" ]; then
	ffmpeg -i "${f}"  2>&1 \
		| grep -e Stream -e Duration -e Input
	exit 0
fi


########################## gui output ###############################
[ ! -z "${w##*[!0-9]*}" ]	&& WIDTH=$f		|| WIDTH=800
[ ! -z "${h##*[!0-9]*}" ]	&& HEIGHT=$f	|| HEIGHT=240
[ -n "${t}" ]				&& TITLE=$t		|| TITLE="Media Info for: $(basename "${f}")"



ffmpeg -i "${f}"  2>&1 \
	| grep -e Stream -e Duration -e Input \
	| zenity --width=${WIDTH} --height=${HEIGHT} --text-info --title "${TITLE}"

exit 0

