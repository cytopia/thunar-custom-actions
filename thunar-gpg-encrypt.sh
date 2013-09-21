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
gpg --sign --encrypt $1
