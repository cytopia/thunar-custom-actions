#!/bin/bash
#
# List available public recipient keys, encrypt the file/folder
# for the specified recipient by his/her public key 
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

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

source $DIR/thunar-gpg-functions.sh

checkCommandLineArg
checkFileArg
checkBinaryReq

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

# Encrypt folder
if [ -d "${f}" ]; then
	parentdir="$(dirname "${f}")"
	directory="$(basename "${f}")"

	error="$(tar c -C "${parentdir}" "${directory}" | gpg -e --yes --batch --local-user "${u}" --recipient "${r}" -o "${parentdir}/${directory}.tar.gpg" 2>&1)"
	errno=$?
else
	error="$(gpg -e --yes --batch --local-user "${u}" --recipient "${r}" "${f}" 2>&1)"
	errno=$?
fi

if [ "$errno" -gt "0" ]; then
	zenity --error --text="${error}\nreturn code: ${errno}"
	exit 1
else
	zenity --info --text="Encrypted."
	exit $?
fi

