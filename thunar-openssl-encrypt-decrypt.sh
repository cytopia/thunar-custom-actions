#!/usr/bin/env bash
#
# Symmetric encryption and decryption using openssl.
#
# * Put this file into your home binary dir: ~/bin/
# * Make it executable: chmod +x
#
#
# Required Software:
# -------------------------
#   * openssl
#	* zenity
#
#
# Thunar Integration
# ------------------------
#
#   Command:      ~/bin/thunar-openssl-encrypt-decrypt.sh -f %f
#   File Pattern: *
#   Appear On:    Select everything
#
#
# Usage:
# -------------------------
#   thunar-openssl-encrypt-decrypt.sh -f <filename>
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
if ! command -v openssl >/dev/null 2>&1 ; then
	echo "Error - 'gpg' not found." 1>&2
	exit 1
fi

# Check if zenity exists
if ! command -v zenity >/dev/null 2>&1 ; then
	echo "Error - 'zenity' not found." 1>&2
	exit 1
fi


chooseOptions () {
	algorithms=$(openssl enc -ciphers 2>&1 \
		| grep '^-' \
		| xargs \
		| sed -e 's/^-//' -e 's/ -/|/g')

	CMD="zenity --forms \
		--title=\"Encryption/Decryption with OpenSSL\" \
		--separator=\"|\" \
		--add-combo=\"Action\" \
		--combo-values=\"Encrypt|Decrypt\" \
		--add-combo=\"Algorithm\" \
		--combo-values=\"${algorithms}\" \
		--add-password=\"key\""

	eval "${CMD}"
}


IFS="|" read -ra options <<< "$(chooseOptions)"

if [ -z "${options[0]}" ]; then
	zenity --error --text="No action to perform."
	exit 1
elif [ -z "${options[1]}" ]; then
	zenity --error --text="No algorithm."
	exit 1
elif [ -z "${options[2]}" ]; then
	zenity --error --text="No passphrase."
	exit 1
fi

cmd_option=""
extension=".out"

case ${options[0]} in
	"Encrypt" ) cmd_option="-e" ; extension=".enc"
		;;
	"Decrypt" ) cmd_option="-d" ; extension=".dec"
		;;
esac

alg="-${options[1]}"

error="$(openssl enc ${cmd_option} "${alg}" -md sha1 -k "${options[2]}" -in "${f}" -out "${f}${extension}" 2>&1)"
errno=$?

if [ "$errno" -gt "0" ]; then
	zenity --error --text="${error}\nreturn code: ${errno}"
	exit 1
else
	zenity --info --text="${options[0]}ed."
	exit $?
fi
