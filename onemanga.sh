#!/bin/bash

_limit=100k
agent="Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.0.3) Gecko/2008092510 Ubuntu/8.04 (hardy) Firefox/3.0.3 (Linux Mint)"

case $# in
    1)
	case `echo ${1} | sed 's/^\(.\).*/\1/'` in
            n) manga="Naruto" ;;
            b) manga="Bleach" ;;
            o) manga="One_Piece" ;;
            h) manga="Historys_Strongest_Disciple_Kenichi" ;;
            r) manga="Real" ;;
	    y) manga="Yokohama_Kaidashi_Kikou";;
            *) cat >> /dev/stderr <<EOF
Supported prefixes:
  n    Naruto
  b    Bleach
  o    One Piece
  h    Historys Strongest Disciple Kenichi
  r    Real
  y    Yokohama Kaidashi Kikou
EOF
		exit 1
		;;
	esac
	chapter=`echo ${1} | sed 's/^.\(.*\)/\1/'`
	;;
    
    2)
	manga="${1}"
	chapter="${2}"
	;;
    
    *)
	cat >> /dev/stderr <<EOF
Usage: ${0##*/} n|b|oCHAPTER | MANGA CHAPTER
example: ${0##*/} n213
         ${0##*/} One_Piece 314
EOF
	exit 1
esac

dir="${manga}_${chapter}"
if [[ ! -d "${dir}" ]]; then
    mkdir "${dir}"
fi
cd "${dir}"

chap_url="http://www.onemanga.com/${manga}/${chapter}/"
page_url=$(wget -U "${agent}" -q -O -  "${chap_url}" | sed -n 's/.\+href="\(.\+\)".\+Begin reading.\+/\1/p')
url=$(wget -U "${agent}" -q -O - "http://www.onemanga.com/${page_url}"| grep -m 1 -o 'http://.*\.onemanga\.com/.*\.jpg')
url=${url%/*}
images=$(wget -U "${agent}" -q -O - "http://www.onemanga.com/${page_url}" | egrep 'option value="..*"' | sed 's/.*value="\(.*\)".*/\1/')

for img in ${images}; do
    wget -U "${agent}" --limit-rate=$_limit -c "${url}/${img}.jpg"
done
