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
#	* gawk
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

# Check if curl exists
if ! command -v curl >/dev/null 2>&1 ; then
	echo "Error - 'curl' not found." 1>&2
	exit 1
fi

# Check if gawk exists
if ! command -v gawk >/dev/null 2>&1 ; then
	echo "Error - 'gawk' not found." 1>&2
	exit 1
fi

TITLE='Uploading to Imgur...'$(basename "${f}")

IMGUR_CLIENT_ID="3e7a4deb7ac67da"
TMPFILE=$(mktemp)

[ ! -z "${w##*[!0-9]*}" ]	&& WIDTH=$w		|| WIDTH=350
[ ! -z "${h##*[!0-9]*}" ]	&& HEIGHT=$h	|| HEIGHT=140
[ -n "${t}" ]				&& TITLE="${t}"	|| TITLE="Uploading to imgur: $(basename "${f}")"

curl -# -F "image"=@"$f" -o "${TMPFILE}" -F title="${TITLE}" -H "Authorization: Client-ID ${IMGUR_CLIENT_ID}" https://api.imgur.com/3/upload.xml 2>&1 | gawk -v RS='\r' '{print $2; fflush("") }' | zenity --width="${WIDTH}" --height="${HEIGHT}" --progress --title="${TITLE}" --text="${TITLE}" --auto-close --time-remaining
#curl -# -F "image"=@"$f" -F "key"="4907fcd89e761c6b07eeb8292d5a9b2a" http://imgur.com/api/upload.xml | grep -Eo "[0-9]{1,3}" | zenity --width=${WIDTH} --height=${HEIGHT} --progress --title="${TITLE}" --text="${TITLE}" --auto-close --time-remaining
#stdbuf -oL tr $'\r' $'\n' | stdbuf -oL grep --line-buffered -Eo '([0-9]+)\.[0-9]%$' | zenity --width=${WIDTH} --height=${HEIGHT} --progress --title="${TITLE}" --text="${TITLE}" --auto-close --time-remaining

########################## gui output ###############################
[ -n "${t}" ]				&& TITLE=$t		|| TITLE="Uploaded to imgur: $(basename "${f}")"


TEXT=$(cat "${TMPFILE}")
rm "${TMPFILE}"

#TAG="$(echo "${TEXT}" | grep -Eo '<[a-z_]+>http' | sed -e "s/http//" | sed -e "s/<//" | sed -e "s/>//")"
#URL="$(echo "${TEXT}" | grep -Eo 'http[^<]+')"
#ZTEXT=""
#urls=($URL)
#tags=($TAG)

URL="$(echo "${TEXT}" | grep -E -m 1 -o "<link>(.*)</link>" | sed -e 's,.*<link>\([^<]*\)</link>.*,\1,g')"
ZTEXT="Direct URL: <a href=\"$URL\">$URL</a>"

#for ((i = 0; i < ${#urls[@]}; i++))
#do
#	ZTEXT="$ZTEXT${tags[$i]}' <a href=\"${urls[$i]}\">${urls[$i]}</a>\n"
#done
zenity --width=${WIDTH} --height=${HEIGHT} --info --title "${TITLE}" --text="${ZTEXT}"
exit $?

