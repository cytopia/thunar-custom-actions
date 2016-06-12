#!/bin/sh
#
# List available public recipient keys, encrypt the file/folder
# for the specified recipient by his/her public key and sign it
# with your own key.
#
# * Put this file into your home binary dir: ~/bin/
# * Make it executable: chmod +x
#
#
# Required Software:
# -------------------------
#   * gpg
#	* zenity
#	* pinentry-gtk-2 or pinentry-mac
#
#
# Thunar Integration
# ------------------------
#
#   Command:      ~/bin/thunar-gpg-encrypt.sh -f %f
#   File Pattern: *
#   Appear On:    Select everything
#
#
# Usage:
# -------------------------
#   thunar-gpg-encrypt.sh -f <filename>/<directory>
#
#     required:
#      -f    input filename/directory
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


#
# Display usage
#
usage() {
	echo "$0 -f <filename>/<folder>"
	echo
	echo " required:"
	echo "   -f    input filename/folder"
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
	_mail="$(gpg --list-secret-keys | grep -A 1 "${_sec}" | tail -n1 | sed 's/uid[[:space:]]*//g')"

	echo "${_mail}"
}


#
# Display zenity box for choosing the recipient
# from a list of all public key.
#
# @output	string	Public key string (bits, key, name, email)
#
chooseRecipient () {

	pubkeys="$(gpg --list-public-keys \
	  | grep -A 1 "^pub" \
	  | sed -n -e "s:^pub *\([A-Za-z0-9]\+\)/\([A-F0-9]\+\) .*$:\1 \2:p" -e "s:^uid *\(.*\)$:\"\1\":p" \
	  | tr '\n' ' ')"


	CMD="zenity --list \
	       --width=550 --height=250 \
	       --title=\"GPG Encrypt File for...\" \
	       --print-column=2 \
	       --text=\"Choose Recipient\" \
	       --column=\"Bit\" --column=\"Key\" --column=\"Recipient\" ${pubkeys}"

	eval "${CMD}"
}


#
# Display zenity box for choosing your own private keys
# from a list.
#
# @output	string	Private key string (bits, key, name, email)
#
chooseSecret () {

	seckeys="$(gpg --list-secret-keys \
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



################################################################################
#
# Evaluate command line arguments
#
################################################################################

# Loop over cmd args
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

# Check if zenity exists
if ! command -v zenity >/dev/null 2>&1 ; then
	echo "Error - 'zenity' not found." 1>&2
	exit 1
fi

# Check if input is file or folder
if [ ! -f "${f}" ] && [ ! -d "${f}" ]; then
	zenity --error --text="Input is neither a file, nor a folder."
	exit 1
fi




################################################################################
#
# Main entry point
#
################################################################################


r="$(chooseRecipient)"
if [ -z "${r}" ]; then
	zenity --error --text="No Recipient specified."
	exit 1
fi
# fix zenity bug on double click
# https://bugzilla.gnome.org/show_bug.cgi?id=698683
r="$(echo "${r}" | awk '{split($0,a,"|"); print a[1]}')"



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


# Encrypt folder
if [ -d "${f}" ]; then
	parentdir="$(dirname "${f}")"
	directory="$(basename "${f}")"

	error="$(tar c -C "${parentdir}" "${directory}" | gpg -e -s --yes --batch --local-user "${u}" --recipient "${r}" --passphrase "${p}" -o "${parentdir}/${directory}.tar.gpg" 2>&1)"
	errno=$?
else
	error="$(gpg -e -s --yes --batch --local-user "${u}" --recipient "${r}" --passphrase "${p}" "${f}" 2>&1)"
	errno=$?
fi

if [ "$errno" -gt "0" ]; then
	zenity --error --text="${error}\nreturn code: ${errno}"
	exit 1
else
	zenity --info --text="Encrypted."
	exit $?
fi


