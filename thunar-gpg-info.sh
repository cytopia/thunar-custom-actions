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


################################################################################
#
# GPG INFO FUNCTIONS
#
################################################################################
validate () {
	_file="${1}"
	error="$(gpg --list-packets --list-only "${_file}" 2> /dev/null)"
	echo $?
}
getRecipientKey() {
	_file="${1}"

	gpg --list-packets --list-only "${_file}" 2>/dev/null | \
		grep 'pubkey' | \
		sed 's/.*keyid//g' | \
		grep -oE '[A-Fa-f0-9]+'
}
getEncrypterKey() {
	_file="${1}"

	gpg --passphrase '' --list-packets --batch --yes "${_file}" 2>&1 | \
		grep -oE '[[:space:]]+ID[[:space:]]+[A-Fa-f0-9]+' | \
		sed 's/^[[:space:]]*ID[[:space:]]*//g'
}
################################################################################
#
# GET PUBLIC KEYS
#
################################################################################
getNameByPubKey() {
	_key="${1}"
	if [ "${_key}" = "" ]; then
		echo ""
		return
	fi
	gpg --list-public-keys --keyid-format short "${_key}" 2>/dev/null | \
		grep '^uid' | \
		sed 's/^uid[[:space:]]*//g' | \
		 sed 's/\s*<.*@.*>$//g'
}
getMailByPubKey() {
	_key="${1}"
	if [ "${_key}" = "" ]; then
		echo ""
		return
	fi
	gpg --list-public-keys --keyid-format short "${_key}" 2>/dev/null | \
		grep '^uid' | \
		sed 's/^uid[[:space:]]*//g' | \
		grep -oE '<.+@.+>' | \
		sed 's/<//g' | \
		sed 's/>//g'

}
getBitByPubKey() {
	_key="${1}"
	if [ "${_key}" = "" ]; then
		echo ""
		return
	fi
	gpg --list-public-keys --keyid-format short "${_key}" 2>/dev/null | \
		grep '^pub' | \
		sed 's/^pub[[:space:]]*//g' | \
		grep -oE '[0-9]+./' | \
		grep -oE '[0-9]+'
}

################################################################################
#
# SECRET KEY FUNCTIONS
#
################################################################################
getNameBySecKey() {
	_key="${1}"
	if [ "${_key}" = "" ]; then
		echo ""
		return
	fi
	gpg --list-secret-keys --keyid-format short "${_key}" 2>/dev/null | \
		grep '^uid' | \
		sed 's/^uid[[:space:]]*//g' | \
		 sed 's/\s*<.*@.*>$//g'
}
getMailBySecKey() {
	_key="${1}"
	if [ "${_key}" = "" ]; then
		echo ""
		return
	fi
	gpg --list-secret-keys --keyid-format short "${_key}" 2>/dev/null | \
		grep '^uid' | \
		sed 's/^uid[[:space:]]*//g' | \
		grep -oE '<.+@.+>' | \
		sed 's/<//g' | \
		sed 's/>//g'

}
getBitBySecKey() {
	_key="${1}"
	if [ "${_key}" = "" ]; then
		echo ""
		return
	fi
	gpg --list-secret-keys --keyid-format short "${_key}" 2>/dev/null | \
		grep '^sec' | \
		sed 's/^sec[[:space:]]*//g' | \
		grep -oE '[0-9]+./' | \
		grep -oE '[0-9]+'
}




error="$( validate "${f}" )"
getEncrypterKey "${f}"
if [ "$error" -eq "0" ]; then
	encrypterKey="$( getEncrypterKey "${f}" )"
	encrypterName="$( getNameBySecKey "${encrypterKey}" )"
	encrypterMail="$( getMailBySecKey "${encrypterKey}" )"

	recipientKey="$( getRecipientKey "${f}" )"
	recipientName="$( getNameByPubKey "${recipientKey}" )"
	recipientMail="$( getMailByPubKey "${recipientKey}" )"

	output=""
	output="${output}Encrypted by:\n"
	output="${output}--------------------------------------------------\n"
	output="${output}Name: ${encrypterName}\n"
	output="${output}Mail: ${encrypterMail}\n"
	output="${output}Key: ${encrypterKey}\n"
	output="${output}\n"
	output="${output}Encrypted for:\n"
	output="${output}--------------------------------------------------\n"
	output="${output}Name: ${recipientName}\n"
	output="${output}Mail: ${recipientMail}\n"
	output="${output}Key: ${recipientKey}\n"

	zenity --info --text="${output}"
	exit $?
else
	zenity --info --text="No valid gpg data found"
	exit 1
fi

