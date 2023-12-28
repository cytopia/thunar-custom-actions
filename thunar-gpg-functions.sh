#!/bin/bash
#
# Common functions used for encryptions
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
# Note:
# -------------------------
#
# Feel free to adjust/improve and commit back to:
#  https://github.com/cytopia/thunar-custom-actions
#

################################################################################
# 
# Common variables
#
################################################################################

export sedUIDExtractionString="s/^\(pub\|sec\)[[:space:]]*[A-Za-z]\{3\}[0-9]*.\///g"

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


################################################################################
#
# Evaluate command line arguments
#
################################################################################

# Loop over cmd args
checkCommandLineArg() {
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
}

# Check if file is specified
checkFileArg()  {
	if [ -z "${f}" ]; then
		echo "Error - no file specified" 1>&2;
		usage
		exit 1
	fi
}

################################################################################
#
# Check binary requirements
#
################################################################################

checkBinaryReq()  {
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

	# Check if input is file or folder
	if [ ! -f "${f}" ] && [ ! -d "${f}" ]; then
		zenity --error --text="Input is neither a file, nor a folder."
		exit 1
	fi
}



################################################################################
#
# GET PUBLIC KEYS
#
################################################################################
getAllPubKeysShort() {
	gpg --list-public-keys --keyid-format short 2>/dev/null | \
		grep '^pub' | \
		sed ${sedUIDExtractionString} | \
		grep -oE '^[0-9A-Fa-f]+'
}
getNameByPubKey() {
	_key="${1}"
	if [ "${_key}" = "" ]; then
		echo ""
		return
	fi
	gpg --list-public-keys --keyid-format short "${_key}" 2>/dev/null | \
		grep '^uid' | \
		sed ${sedUIDExtractionString} | \
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
		sed ${sedUIDExtractionString} | \
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
		sed ${sedUIDExtractionString} | \
		grep -oE '[0-9]+./' | \
		grep -oE '[0-9]+'
}


################################################################################
#
# GET PRIVATE KEYS
#
################################################################################
getAllSecKeysShort() {
	gpg --list-secret-keys --keyid-format short 2>/dev/null | \
		grep '^sec' | \
		sed ${sedUIDExtractionString} | \
		grep -oE '^[0-9A-Fa-f]+'
}
getNameBySecKey() {
	_key="${1}"
	if [ "${_key}" = "" ]; then
		echo ""
		return
	fi
	gpg --list-secret-keys --keyid-format short "${_key}" 2>/dev/null | \
		grep '^uid' | \
		sed ${sedUIDExtractionString} | \
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
		sed ${sedUIDExtractionString} | \
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
		sed ${sedUIDExtractionString} | \
		grep -oE '[0-9]+./' | \
		grep -oE '[0-9]+'
}






################################################################################
#
# ZENITY FUNCTIONS
#
################################################################################


#
# Display zenity box for choosing the recipient
# from a list of all public key.
#
# @output	string	Public key string (bits, key, name, email)
#
chooseRecipient () {
	output=""
	IFS='
'
	for key in $( getAllPubKeysShort ); do
		name="$( getNameByPubKey "${key}" )"
		mail="$( getMailByPubKey "${key}" )"
		bit="$( getBitByPubKey "${key}" )"
		output="${output}\"${bit}\" \"${key}\" \"${name}\" \"${mail}\" "
	done

	CMD="zenity --list \
	       --width=550 --height=250 \
	       --title=\"GPG Encrypt File for...\" \
	       --print-column=2 \
	       --text=\"Choose Recipient\" \
	       --column=\"Bit\" --column=\"Key\" --column=\"Name\" --column=\"Email\" ${output}"

	eval "${CMD}"
}


#
# Display zenity box for choosing your own private keys
# from a list.
#
# @output	string	Private key string (bits, key, name, email)
#
chooseSecret () {
	output=""
	IFS='
'
	for key in $( getAllSecKeysShort ); do
		name="$( getNameBySecKey "${key}" )"
		mail="$( getMailBySecKey "${key}" )"
		bit="$( getBitBySecKey "${key}" )"
		output="${output}\"${bit}\" \"${key}\" \"${name}\" \"${mail}\" "
	done

	CMD="zenity --list \
	       --width=550 --height=250 \
	       --title=\"Choose private key...\" \
	       --print-column=2 \
	       --text=\"Choose your private key\" \
	       --column=\"Bit\" --column=\"Key\" --column=\"Name\" --column=\"Email\" ${output}"

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


