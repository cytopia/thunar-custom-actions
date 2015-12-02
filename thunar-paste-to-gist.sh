#!/bin/sh
#
# Paste a file directly to gist.
#
# * Put this file into your home binary dir: ~/bin/
# * Make it executable: chmod +x
#
#
# Required Software:
# -------------------------
#   * zenity
#   * gist
#   * xclip
#
#
# Thunar Integration
# ------------------------
#
#   Command:      ~/bin/thunar-paste-to-gist.sh -f %f
#   File Pattern: *
#   Appear On:    Text Files
#
# Note:
# -------------------------
#
# Feel free to adjust/improve and commit back to:
#  https://github.com/cytopia/thunar-custom-actions
#


usage() {
	echo "$0 -f <filename> [-w width(int)] [-h height(int)] [-t window-title]"
	echo
	echo " required:"
	echo "   -f <filename>   input filename"
	echo
	echo " optional:"
	echo
	echo "   -w              (gui) width of window (e.g.: -w 800)"
	echo "                   default is 800"
	echo
	echo "   -h              (gui) height of window (e.g.: -h 240)"
	echo "                   default is 240"
	echo
	echo "   -t              (gui) window title"
	echo "                   default is filename"
	echo
}


while getopts ":f:cw:h:t:" i; do
	case "${i}" in
		f)
			f=${OPTARG}
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
	exit 1
fi

# Check if zenity exists
if ! command -v zenity >/dev/null 2>&1 ; then
	echo "Error - 'zenity' not found." 1>&2
	exit 1
fi

# Check if zenity exists
if ! command -v gist >/dev/null 2>&1 ; then
	echo "Error - 'gist' not found." 1>&2
	exit 1
fi

# Check if zenity exists
if ! command -v xclip >/dev/null 2>&1 ; then
	echo "Error - 'xclip' not found." 1>&2
	exit 1
fi



########################## gui output ###############################
[ ! -z "${w##*[!0-9]*}" ]	&& WIDTH=$w		|| WIDTH=600
[ ! -z "${h##*[!0-9]*}" ]	&& HEIGHT=$h	|| HEIGHT=240
[ -n "${t}" ]				&& TITLE=$t		|| TITLE="Pasting to gist: $(basename "${f}")"


gist-paste --private --shorten --copy "${f}" \
	| zenity --width=${WIDTH} --height=${HEIGHT} --text-info --title "${TITLE}"
exit $?
