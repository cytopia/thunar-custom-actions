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
#	* zenity
#	* pinentry-gtk-2
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


chooseRecipient () {

	pubkeys=`gpg --list-public-keys \
	  | grep -A 1 pub \
	  | awk '{print $2,$3,$4}' \
	  | egrep -v "^[[:space:]]*$" \
	  | awk 'NR%2{printf $1" ";next;}1' \
	  | awk '{print substr($0,7,8)" "substr($0,1,5)" \""$2,$3,$4"\""}'`


	CMD="zenity --list \
	       --width=550 --height=250 \
	       --title=\"GPG Encrypt File for...\" \
	       --print-column=1 \
	       --text=\"Choose Recipient\" \
	       --column=\"Key\" --column=\"Bit\" --column=\"Recipient\" $pubkeys"

	eval $CMD
}


chooseSecret () {

	seckeys=`gpg --list-secret-keys \
	  | grep -A 1 sec \
	  | awk '{print $2,$3,$4}' \
	  | egrep -v "^[[:space:]]*$" \
	  | awk 'NR%2{printf $1" ";next;}1' \
	  | awk '{print substr($0,7,8)" "substr($0,1,5)" \""$2,$3,$4"\""}'`


	CMD="zenity --list \
	       --width=550 --height=250 \
	       --title=\"Choose private key...\" \
	       --print-column=1 \
	       --text=\"Choose your private key\" \
	       --column=\"Key\" --column=\"Bit\" --column=\"Secret Key\" $seckeys"

	eval $CMD
}

readPassword () {
    echo "GETPIN" | pinentry-gtk-2 2> /dev/null | grep "D" | awk '{print $2}'
}


r=`chooseRecipient`
if [ -z "${r}" ]; then
	zenity --error --text="No Recipient specified."
	exit 1
fi
# fix zenity bug on double click
# https://bugzilla.gnome.org/show_bug.cgi?id=698683
r=`echo $r | awk '{split($0,a,"|"); print a[1]}'`



u=`chooseSecret`
if [ -z "${u}" ]; then
	zenity --error --text="No Secret key specified."
	exit 1
fi
# fix zenity bug on double click
# https://bugzilla.gnome.org/show_bug.cgi?id=698683
u=`echo $u | awk '{split($0,a,"|"); print a[1]}'`



p=`readPassword`
if [ -z "${p}" ]; then
	zenity --error --text="No Password specified."
	exit 1
fi


error=$(gpg -e -s --yes --batch --local-user $u --recipient $r --passphrase $p "${f}" 2>&1)
errno=$?

if [ "$errno" -gt "0" ]; then
	zenity --error --text="${error}\nreturn code: ${errno}"
	exit 1
else
	zenity --info --text="Encrypted."
	exit 0
fi


###### old CMD Version
# show keys so you can choose the recipient

#echo "key        type    recipient"
#echo "---------------------------------------------"
#gpg --list-keys \
#  | grep -A 1 pub \
#  | awk '{print $2,$3,$4}' \
#  | egrep -v "^[[:space:]]*$" \
#  | awk 'NR%2{printf $1" ";next;}1' \
#  | awk '{print substr($0,7,8)"  (" substr($0,1,5)")  "$2,$3,$4,$5}'
#echo "---------------------------------------------"
#
#
## Start interactive encryption
#gpg --sign --encrypt "${f}"
#
#exit 0
