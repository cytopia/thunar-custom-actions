#!/bin/sh
#
# Convert an image file to a jpg file.
#
# * Put this file into your home binary dir: ~/bin/
# * Make it executable: chmod +x
#
#
# Required Software:
# -------------------------
#   * convert
#
#
# Thunar Integration
# ------------------------
#
#   Command:      ~/bin/thunar-convert-to-jpg.sh -f %f
#   File Pattern: *
#   Appear On:    Image Files
#
#
# Usage:
# -------------------------
#   thunar-convert-to-jpg.sh -f <filename>
#
#     required:
#      -f    input filename
#
# Note:
# -------------------------
#
# Feel free to adjust/improve and commit back to:
# https://github.com/cytopia/thunar-custom-actions
#


usage() {
	echo "$0 -f <filename>"
	echo
	echo " required:"
	echo "   -f    input filename"
	echo
}


while getopts ":f:" i; do
	case "${i}" in
		f)
			f=${OPTARG}
			;;
		*)
			echo "Error - unrecognized option $1" 1>&2
			usage
			;;
	esac
done
shift $((OPTIND-1))

# Check if file is specified
if [ -z "${f}" ]; then
	echo "Error - no file specified" 1>&2
	usage
	exit 1
fi

# Check if convert exists
if ! command -v convert >/dev/null 2>&1 ; then
	echo "Error - 'convert' not found." 1>&2
	exit 1
fi

$(which convert) "${f}" "${f}.jpg"
exit $?

