#!/bin/sh
#
# List available public recipient keys, encrypt the file
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
#
#
# Thunar Integration
# ------------------------
#
# replace urxvtcd with your favorite terminal
#
#   Command:      urxvtcd -e ~/bin/thunar-gpg-encrypt.sh -f %f
#   File Pattern: *
#   Appear On:    Select everything
#
#
# Usage:
# -------------------------
#   thunar-gpg-encrypt.sh -f <filename>
#
#     required:
#      -f    input filename
#
# Note:
# -------------------------
#
# Feel free to adjust/improve and commit back to:
#  https://github.com/pantu/thunar-custom-actions
#


usage() {
	echo "$0 -f <filename>"
	echo
	echo " required:"
	echo "   -f    input filename"
	echo
	exit 1
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
fi





#!/bin/sh

# show keys so you can choose the recipient

echo "key        type    recipient"
echo "---------------------------------------------"
gpg --list-keys \
  | grep -A 1 pub \
  | awk '{print $2,$3,$4}' \
  | egrep -v "^[[:space:]]*$" \
  | awk 'NR%2{printf $1" ";next;}1' \
  | awk '{print substr($0,7,8)"  (" substr($0,1,5)")  "$2,$3,$4,$5}'
echo "---------------------------------------------"


# Start interactive encryption
gpg --sign --encrypt "${f}"

exit 0