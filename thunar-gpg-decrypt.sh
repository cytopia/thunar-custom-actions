#!/bin/sh
#
# Decrypt a gpg encrypted file.
#
# * Put this file into your home binary dir: ~/bin/
# * Make it executable: chmod +x
#
#
# Required Software:
# -------------------------
#   * gpg
#
#
# Thunar Integration
# ------------------------
#
# replace urxvtcd with your favorite terminal
#
#   Command:      urxvtcd -e ~/bin/thunar-gpg-decrypt.sh -f %f
#   File Pattern: *
#   Appear On:    Other Files
#
#
# Usage:
# -------------------------
#   thunar-gpg-decrypt.sh -f <filename>
#
#     required:
#      -f    input filename
#
# Note:
# -------------------------
#
# Feel free to adjust/improve and commit back to:
#  https://github.com/cytopia/thunar-custom-actions
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

# Check if gpg exists
if ! command -v gpg >/dev/null 2>&1 ; then
	echo "Error - 'gpg' not found." 1>&2
	exit 1
fi

$(which gpg) -o "${f}.decrypted" -d "${f}"
exit $?

