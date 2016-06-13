#!/bin/sh
#
# Sign a file using gpg (ascii armored)
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
#   Command:      ~/bin/thunar-gpg-sign.sh -f %f
#   File Pattern: *
#   Appear On:    Other Files
#
#
# Usage:
# -------------------------
#   thunar-gpg-sign.sh -f <filename>
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



################################################################################
#
# Functions
#
################################################################################


usage() {
	echo "$0 -f <filename>"
	echo
	echo " required:"
	echo "   -f    input filename"
	echo
}

#
# Get email by secret key.
#
# @param	string	Secret key
# @output	string	Email
#
getMailBySecKey() {
	_sec="$1"
	_mail="$(gpg --list-secret-keys --keyid-format short | grep -A 1 "${_sec}" | tail -n1 | sed 's/uid[[:space:]]*//g')"

	echo "${_mail}"
}



#
# Display zenity box for choosing your own private keys
# from a list.
#
# @output	string	Private key string (bits, key, name, email)
#
chooseSecret () {

	seckeys="$(gpg --list-secret-keys --keyid-format short \
	  | grep -A 1 "^sec" \
	  | sed -n -e "s:^sec *\([A-Za-z0-9]\+\)/\([A-F0-9]\+\) .*$:\1 \2:p" -e "s:^uid *\(.*\)$:\"\1\":p" \
	  | tr '\n' ' ')"


	CMD="zenity --list \
	       --width=550 --height=250 \
	       --title=\"Choose private key...\" \
	       --print-column=2 \
	       --text=\"Choose your private key\" \
	       --column=\"Bit\" --column=\"Key\" --column=\"Secret Key\" ${seckeys}"

	eval "${CMD}"
}


#
# Display secure dialog to read in the pasword
#
# @param	string	My chosen secret key
# @output	string	My entered password
readPassword () {
	_my_key="$1"
	_my_mail="$(getMailBySecKey "${_my_key}")"
	printf "SETDESC Enter your password for: %s (%s)\nGETPIN\n" "${_my_key}" "${_my_mail}" | ${BIN_PINENTRY} 2> /dev/null | grep "D" | awk '{print $2}'
}


sign() {
	key="${1}"	# email or key
	pass="${2}"
	f="${3}"

	output="$(gpg --armor --yes --local-user "${key}" --detach-sign --passphrase "${pass}" "${f}" 2>&1)"
	error=$?
	echo "${output}"
	return $error
}



################################################################################
#
# Evaluate command line arguments
#
################################################################################


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



################################################################################
#
# Check binary requirements
#
################################################################################


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

# Check if pinentry-gtk-2 exists
BIN_PINENTRY=""
if [ "$(uname)" != "Darwin" ]; then
	if ! command -v pinentry-gtk-2 >/dev/null 2>&1 ; then
		echo "Error - 'pinentry-gtk-2' not found." 1>&2
		exit 1
	fi
	BIN_PINENTRY="pinentry-gtk-2"
else
	if ! command -v pinentry-mac >/dev/null 2>&1 ; then
		echo "Error - 'pinentry-mac' not found." 1>&2
		exit 1
	fi
	BIN_PINENTRY="pinentry-mac"
fi


################################################################################
#
# Main entry point
#
################################################################################


u="$(chooseSecret)"
if [ -z "${u}" ]; then
	zenity --error --text="No Secret key specified."
	exit 1
fi
# fix zenity bug on double click
# https://bugzilla.gnome.org/show_bug.cgi?id=698683
u="$(echo "${u}" | awk '{split($0,a,"|"); print a[1]}')"

p="$(readPassword "${u}")"
if [ -z "${p}" ]; then
	zenity --error --text="No Password specified."
	exit 1
fi


output="$(sign "${u}" "${p}" "${f}")"
error=$?

if [ "$error" -eq "0" ]; then
	zenity --info --title="Signature Created" --no-markup --text="Signature successfully created for ${f}"
	exit $?
else
	zenity --error --title="GPG Signature Error" --text="Error creating the signature:\n\n${output}"
	exit 1
fi

