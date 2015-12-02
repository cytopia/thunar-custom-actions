#!/bin/sh
#
# Informs about to whom the file has been encrypted for.
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
#   Command:      ~/bin/thunar-gpg-info.sh -f %f
#   File Pattern: *
#   Appear On:    Other Files
#
#
# Usage:
# -------------------------
#   thunar-gpg-info.sh -f <filename>
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


Validate () {
	error="$(gpg --list-packets --list-only "${f}" 2> /dev/null)"
	echo $?
}


RecipientKey () {
	candidates="$(gpg --list-secret-keys | grep ssb | awk '{print $2}' | awk '{print substr($0,7,8)}')"

	for i in $candidates
	do
		gpg --list-packets --list-only "${f}" | grep "${i}" >/dev/null 2>&1

		if [ $? -eq 0 ]; then
			echo "${i}"
			return
		fi
	done
}

Recipient () {

	key="${1}"
	recipient="$(gpg --list-secret-keys \
              | grep -B 2 "${key}" \
              | grep uid \
			  | awk '{print $2" "$3" "$4}')"

	echo "${recipient}"
}



error="$(Validate)"

if [ "$error" -eq "0" ]; then
	recipientKey="$(RecipientKey)"
	recipient="$(Recipient "${recipientKey}")"
	zenity --info --no-markup --text="Encrypted for: ${recipientKey} ${recipient}"
	exit $?
else
	zenity --info --text="No valid gpg data found"
	exit 1
fi

