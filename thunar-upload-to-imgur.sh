#!/usr/bin/env bash
#
# Upload a Picture to imgur.
#
# * Put this file into your home binary dir: ~/bin/
# * Make it executable: chmod +x
#
#
# Required Software:
# -------------------------
#   * zenity
#   * curl
#
#
# Thunar Integration
# ------------------------
#
#   Command:      ~/bin/thunar-upload-to-imgur.sh -f %f
#   File Pattern: *
#   Appear On:    Image Files
#
#
# Usage:
# -------------------------
#   thunar-upload-to-imgur.sh -f <filename> [-w width(int)] [-h height(int)] [-t window-title]
#
#     required:
#      -f    input filename
#
#     optional:
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
	echo "$0 -f <filename> [-w width(int)] [-h height(int)] [-t window-title]"
	echo
	echo " required:"
	echo "   -f    input filename"
	echo
	echo " optional:"
	echo "   -w    (gui) width of window (e.g.: -w 800)"
	echo "         default is 800"
	echo
	echo "   -h    (gui) height of window (e.g.: -h 240)"
	echo "         default is 240"
	echo
	echo "   -t    (gui) window title"
	echo "         default is filename"
	echo
}


while getopts ":f:cw:h:t:" i; do
	case "${i}" in
		f)
			f="${OPTARG}"
			;;
		w)
			w="${OPTARG}"
			;;
		h)
			h="${OPTARG}"
			;;
		t)
			t="${OPTARG}"
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
if ! command -v curl >/dev/null 2>&1 ; then
	echo "Error - 'curl' not found." 1>&2
	exit 1
fi


########################## gui output ###############################
[ ! -z "${w##*[!0-9]*}" ]	&& WIDTH="${f}"		|| WIDTH="800"
[ ! -z "${h##*[!0-9]*}" ]	&& HEIGHT="${f}"	|| HEIGHT="240"
[ -n "${t}" ]				&& TITLE="${t}"		|| TITLE="Uploading to imgur: $(basename "${f}")"

IMGUR_KEY="4907fcd89e761c6b07eeb8292d5a9b2a"
TEXT="$(curl -# -F "image"=@"${f}" -F "key=${IMGUR_KEY}" http://imgur.com/api/upload.xml)"
TAG="$(echo "${TEXT}" | grep -Eo '<[a-z_]+>http' | sed -e "s/http//" | sed -e "s/<//" | sed -e "s/>//")"
URL="$(echo "${TEXT}" | grep -Eo 'http[^<]+')"
ZTEXT=""
urls=($URL)
tags=($TAG)

for ((i = 0; i < ${#urls[@]}; i++))
do
	ZTEXT="$ZTEXT${tags[$i]}' <a href=\"${urls[$i]}\">${urls[$i]}</a>\n"
done
zenity --width=${WIDTH} --height=${HEIGHT} --info --title "${TITLE}" --text="${ZTEXT}"
exit $?

