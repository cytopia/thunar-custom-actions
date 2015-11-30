#!/usr/bin/env bash
#
# Upload a Picture to imgur.
#
# * Put this file into your home binary dir: ~/bin/
# * Make it executable: chmod +x
#
#
# Required Software:
# -------------------------
#   * zenity
#   * curl
#
#
# Thunar Integration
# ------------------------
#
#   Command:      ~/bin/thunar-upload-to-imgur.sh -f %f
#   File Pattern: *
#   Appear On:    Image Files
#
#
# Usage:
# -------------------------
#   thunar-upload-to-imgur.sh -f <filename> [-w width(int)] [-h height(int)] [-t window-title]
#
#     required:
#      -f    input filename
#
#     optional:
#
#      -w    (gui) width of window (e.g.: -w 800)
#            default is 800
#
#      -h    (gui) height of window (e.g.: -h 240)
#            default is 240
#
#      -t    (gui) window title
#            default is filename
#
# Note:
# -------------------------
#
# Feel free to adjust/improve and commit back to:
#  https://github.com/cytopia/thunar-custom-actions
#


usage() {
	echo "$0 -f <filename> [-w width(int)] [-h height(int)] [-t window-title]"
	echo
	echo " required:"
	echo "   -f    input filename"
	echo
	echo " optional:"
	echo "   -w    (gui) width of window (e.g.: -w 800)"
	echo "         default is 800"
	echo
	echo "   -h    (gui) height of window (e.g.: -h 240)"
	echo "         default is 240"
	echo
	echo "   -t    (gui) window title"
	echo "         default is filename"
	echo
	exit 1
}


while getopts ":f:cw:h:t:" i; do
	case "${i}" in
		f)
			f=${OPTARG}
			;;
		c)
			c=yes
			;;
		w)
			w=${OPTARG}
			;;
		h)
			h=${OPTARG}
			;;
		t)
			t=${OPTARG}
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


# Console (TODO:)
# curl -# -F "image"=@"$f" -F "key"="4907fcd89e761c6b07eeb8292d5a9b2a" http://imgur.com/api/upload.xml \
#	| grep -Eo '<[a-z_]+>http[^<]+' \
#	| sed 's/^<.\|_./\U&/g;s/_/ /;s/<\(.*\)>/\x1B[0;34m\1:\x1B[0m /'



########################## gui output ###############################
[ ! -z "${w##*[!0-9]*}" ]	&& WIDTH=$f		|| WIDTH=800
[ ! -z "${h##*[!0-9]*}" ]	&& HEIGHT=$f	|| HEIGHT=240
[ -n "${t}" ]				&& TITLE=$t		|| TITLE="Uploading to imgur: `basename "${f}"`"



#TEXT=$(curl -F "image"=@"$f" -F "key"="a3793a1cce95f32435bb002b92e0fa5e" http://imgur.com/api/upload.xml | sed -e "s/.*<imgur_page>//" | sed -e "s/<.*//")
#zenity --info --title="Imgur Upload" --text="$TEXT"

TEXT=$(curl -# -F "image"=@"$f" -F "key"="4907fcd89e761c6b07eeb8292d5a9b2a" http://imgur.com/api/upload.xml ) 
#TEXT='<?xml version="1.0" encoding="utf-8"?> <rsp stat="ok"><image_hash>d5gSMGf</image_hash><delete_hash>doB1PJ99oDkMiKm</delete_hash><original_image>http://i.imgur.com/d5gSMGf.png</original_image><large_thumbnail>http://i.imgur.com/d5gSMGfl.jpg</large_thumbnail><small_thumbnail>http://i.imgur.com/d5gSMGfs.jpg</small_thumbnail><imgur_page>http://imgur.com/d5gSMGf</imgur_page><delete_page>http://imgur.com/delete/doB1PJ99oDkMiKm</delete_page></rsp>'
TAG=$(echo $TEXT |grep -Eo '<[a-z_]+>http' |sed -e "s/http//" |sed -e "s/<//" |sed -e "s/>//")
URL=$(echo $TEXT |grep -Eo 'http[^<]+')
ZTEXT=""
urls=($URL)
tags=($TAG)
for ((i = 0; i < ${#urls[@]}; i++))
do
	ZTEXT=$ZTEXT${tags[$i]}' <a href="'${urls[$i]}'">'${urls[$i]}'</a>\n'
done
zenity --info --title "${TITLE}" --text="${ZTEXT}" #'<a href="http://goat.cx">klik</a>' #''$ZTEXT''


#curl -# -F "image"=@"$f" -F "key"="4907fcd89e761c6b07eeb8292d5a9b2a" http://imgur.com/api/upload.xml \
#	| grep -Eo '<[a-z_]+>http[^<]+' \
#	| zenity --width=${WIDTH} --height=${HEIGHT} --text-info --title "${TITLE}"
