#!/bin/sh

#
# Considering not to use the built-in pastebin api,
# because it is limit, but rather POST to the real site
# and see what regex can do to get all the infos.
#


# Feel free to adjust
USERAGENT="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6"

# Pastebin API
# @see http://pastebin.com/api

# TODO:
# would be nice to have an array of keys to choose from
# Or maybe pastebin is giving an official key to this tool
# For now, this is a random generated key that I am not using.
#PB_API_KEY="1cc4d307b5a37854434f262ea6f4aaac"
PB_API_KEY="45472181634ec09cafed2341da212cd3"

# Required stuff
PB_API_URL="http://pastebin.com/api/api_post.php"
PB_API_OPT="paste"

# The string being pasted
PB_API_PASTE=""

# TODO:
# autodetect based on file extension of file being pasted
PB_API_FORMAT="text"



get_api_format() {
	file="$1"
	default="text"
	type="$(file "${file}")"

	# Add all file types here
	# @see http://pastebin.com/api#5
	case $type in
		*POSIX*shell* | *bash*script*)
			echo "bash"
			;;
		*PHP*script*)
			echo "php"
			;;
		*)
			echo "${default}"
			;;
	esac
}

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

[ ! -z "${w##*[!0-9]*}" ]	&& WIDTH=$w		|| WIDTH=350
[ ! -z "${h##*[!0-9]*}" ]	&& HEIGHT=$h	|| HEIGHT=140
[ -n "${t}" ]				&& TITLE="${t}"	|| TITLE="Pastebin: $(basename "${f}")"

# Read in the file
PB_API_PASTE="$(cat "${f}")"

# Figure out the correct format for syntax highlighting via `file`
PB_API_FORMAT="$(get_api_format "${f}")"


# The output will only contain the url or an error if something went wrong
ZTEXT="$($(which curl) --silent --show-error --user-agent "${USERAGENT}" --data api_option=${PB_API_OPT} --data api_paste_format=${PB_API_FORMAT} --data api_dev_key=${PB_API_KEY} --data-urlencode api_paste_code="\"${PB_API_PASTE}\"" $PB_API_URL)"

zenity --width=${WIDTH} --height=${HEIGHT} --info --title "${TITLE}" --text="${ZTEXT}"
exit

