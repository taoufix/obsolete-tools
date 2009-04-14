#!/bin/bash

url=`wget -q -O - 'http://www.printsudoku.com/index-en.html' | egrep -o 'http://www.printsudoku.com/print-sudoku-[0-9]+.html'`

if (( $? != 0 )); then
        echo "Sudoku html page not found"
        exit 1
fi

pdf=`wget -q -O - "${url}" | egrep  -o 'URL=download/en/.*\.pdf'`

if (( $? != 0 )); then
        echo "Sudoku pdf file not found"
        exit 1
fi

wget -q -O - http://www.printsudoku.com/${pdf/URL=/} | lpr

