#!/bin/bash

if (($# != 2)); then
    echo "usage $0 YY MM"
    exit 1
fi

limit="10k"
url="http://www.japanesepod101.com/20${1}/${2}/"
#url="http://www.japanesepod101.com/20${1}/${2}/?cat=0&order=asc"
next='next &raquo;'
file=`mktemp /tmp/jpod.XXXXXXXXXX`

while [[ -n "${url}" ]]; do
    # get html file
    echo ">>>>  " $url
    rm -f ${file}
    wget -q -U Lynx -O ${file} ${url}

    # download mp3 listed in html file
    for m in `grep -o '/[^/]*101\.pdf' ${file} | sed s/pdf/mp3/ | sed 's+/++'`; do
	wget --limit-rate=${limit} -c -U Lynx -O ${m} "http://media.libsyn.com/media/japanesepod101/${m}"
    done
    
    #for mp3 in `grep -o  '"http://media.libsyn.com/media/japanesepod101/[^ ]*\.mp3"' ${file}`; do
    #    wget --limit-rate=${limit} -c -U Lynx ${mp3//\"/} -O `sed 's+"http://.*/japanesepod101/\(.*\.mp3\).*+\1+' <<<${mp3}`
    #done

    

    # look for next page
    if grep "${next}" ${file} &>/dev/null; then
	# if there's one, mark it for download
	url=`grep "${next}" ${file}  | sed 's+.*<a href="\(http://www.japanesepod101.com/200[0-9]/[0-9][0-9]/page/[1-9]/\)">next &raquo;</a>.*+\1+'`
    else
	# we're done, this will end the loop
	unset url
    fi
done

# clean up
rm -f ${file}
