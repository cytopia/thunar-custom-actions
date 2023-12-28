#!/bin/sh
#
# Decrypt a gpg encrypted file.
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
#   Command:      urxvtcd -e ~/bin/thunar-gpg-decrypt.sh -f %f
#   File Pattern: *
#   Appear On:    Other Files
#
#
# Usage:
# -------------------------
#   thunar-gpg-decrypt.sh -f <filename>
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

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

source $DIR/thunar-gpg-functions.sh

checkCommandLineArg
checkFileArg
checkBinaryReq


# remove ".gpg" file extension if it exists
output="$( echo "${f}" | sed 's/\(\.gpg\|\.asc\)$//g' )"

$(which gpg) -o "${output}" -d "${f}"
exit $?

