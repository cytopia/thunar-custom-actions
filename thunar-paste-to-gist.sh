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
#
#
# Thunar Integration
# ------------------------
#
#   Command:      thunar-paste-to-gist.sh -f %f
#   File Pattern: *
#   Appear On:    Text Files
#
#
# Usage:
# -------------------------
#   thunar-paste-to-gist.sh -f <filename> [-w width(int)] [-h height(int)] [-t window-title]
#
#     required:
#      -f    input filename
#
#     optional:
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
#  https://github.com/pantu/thunar-custom-actions
#


usage() {
	echo "$0 -f <filename> [-w width(int)] [-h height(int)] [-t window-title]"
	echo
	echo " required:"
	echo "   -f    input filename"
	echo
	echo " optional:"
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



########################## gui output ###############################
[ ! -z "${w##*[!0-9]*}" ]	&& WIDTH=$f		|| WIDTH=600
[ ! -z "${h##*[!0-9]*}" ]	&& HEIGHT=$f	|| HEIGHT=240
[ -n "${t}" ]				&& TITLE=$t		|| TITLE=$f


gist --private --shorten --copy  $f \
	| zenity --width=${WIDTH} --height=${HEIGHT} --text-info --title $TITLE
exit 0