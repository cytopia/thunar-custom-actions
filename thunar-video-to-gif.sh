#!/bin/sh
#
# Convert a video file to an animated gif (high quality mode).
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
#   Command:      ~/bin/thunar-video-to-gif.sh -f %f -t %n
#   File Pattern: *
#   Appear On:    Video Files
#
#
# Usage:
# -------------------------
#   thunar-video-to-gif.sh -f <filename> [-c]
#
#     required:
#      -f    input filename
#
#     optional:
#      -c    no-gui, show console output (zenity not required)
#            default is to show gui
#
#
# Note:
# -------------------------
#
# Feel free to adjust/improve and commit back to:
#  https://github.com/cytopia/thunar-custom-actions
#

# Test if argument is an integer.
#
# @param  mixed
# @return integer	0: is number | 1: not a number
isint(){
	printf "%d" "${1}" >/dev/null 2>&1 && return 0 || return 1;
}


usage() {
	echo "$0 -f <filename> [-c]"
	echo
	echo " required:"
	echo "   -f    input filename"
	echo
	echo " optional:"
	echo "   -c    no-gui, show console output (zenity not required)"
	echo "         default is to show gui"
	echo
	exit 1
}


# No console output
c="no"

while getopts ":f:c" i; do
	case "${i}" in
		f)
			f=${OPTARG}
			;;

		# Console output instead of zenity
		c)
			c="yes"
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

# Check for mktemp
if ! command -v mktemp >/dev/null 2>&1 ; then
	echo "Error - 'mktemp' not found (requited to build the palette)." 1>&2
	exit 1
fi

# Check if zenity exists (on gui output)
if [ "${c}" != "yes" ]; then
	if ! command -v zenity >/dev/null 2>&1 ; then
		echo "Error - 'zenity' not found." 1>&2
		exit 1
	fi
fi

# Check if ffmpeg exists
if ! command -v ffmpeg >/dev/null 2>&1 ; then
	echo "Error - 'ffmpeg' not found." 1>&2
	exit 1
fi



########################## OPTIONS ###############################



# Tmpfile for palette (to produce better quality)
FILE_PALETTE="$(mktemp).png"


########################## console output ###############################

# Do we have textbased output?
if [ "${c}" = "yes" ]; then

	while true; do
		# shellcheck disable=SC2039
		read -r -p "Enter output video width in pixel (integer): " VIDEO_WIDTH

		if ! isint "${VIDEO_WIDTH}"; then
			echo "Please enter a valid integer"
		else
			break;
		fi
	done

	# FFMPEG Filters
	FF_FILTERS="fps=15,scale=${VIDEO_WIDTH}:-1:flags=lanczos"


	ffmpeg -v warning -i "${f}" -vf "${FF_FILTERS},palettegen" -y "${FILE_PALETTE}"
	ffmpeg -v warning -i "${f}" -i "${FILE_PALETTE}" -lavfi "${FF_FILTERS} [x]; [x][1:v] paletteuse" -y "${f}.gif"


########################## gui output ###############################

else

	while true; do
		VIDEO_WIDTH="$(zenity --entry --title="Video width" --text="Enter output video width in pixel (integer):")"

		if ! isint "${VIDEO_WIDTH}"; then
			zenity --error --text="Not a valid integer"
		else
			break;
		fi
	done

	# FFMPEG Filters
	FF_FILTERS="fps=15,scale=${VIDEO_WIDTH}:-1:flags=lanczos"

	ffmpeg -v warning -i "${f}" -vf "${FF_FILTERS},palettegen" -y "${FILE_PALETTE}" |  zenity --title="Run 1/2" --text="Run 1/2\nCreating palette for better quality" --progress --pulsate
	ffmpeg -v warning -i "${f}" -i "${FILE_PALETTE}" -lavfi "${FF_FILTERS} [x]; [x][1:v] paletteuse" -y "${f}.gif" | zenity --title="Run 2/2" --text="Run 2/2\n Converting Video to gif" --progress --pulsate

fi

rm "${FILE_PALETTE}"
exit 0
