#!/bin/sh
#
# Verify the gpg signature of *.asc or *.sig files.
#
# * Put this file into your home binary dir: ~/bin/
# * Make it executable: chmod +x
#
#
# Required Software:
# -------------------------
#   * gpg
#	* zenity
#
#
# Thunar Integration
# ------------------------
#
#   Command:      ~/bin/thunar-gpg-verify-signature.sh -f %f
#   File Pattern: *
#   Appear On:    Other Files
#
#
# Usage:
# -------------------------
#   thunar-gpg-verify-signature.sh -f <filename>
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

# Check if zenity exists
if ! command -v zenity >/dev/null 2>&1 ; then
	echo "Error - 'zenity' not found." 1>&2
	exit 1
fi


verify() {
	output="$(gpg --keyid-format 0xlong --verify "${f}" 2>&1)"
	error=$?
	echo "${output}"
	return $error
}


output="$(verify "${f}")"
error=$?

if [ "$error" -eq "0" ]; then
	zenity --info --title="GPG Good signature" --no-markup --text="${output}"
	exit $?
else
	zenity --error --title="GPG Signature Error" --text="Error verifying the signature:\n\n${output}"
	exit 1
fi

