#! /bin/sh

if [ "$1" == ""  ]; then
	echo "[USAGE] $0 filename:"
	exit
fi


fname=${1%%.}
if [ "$1" == "$fname" ]; then
	vim $*
else
    path=${1%/*}
    fname=${1##*/}
	if [ "$path" == "$fname" ]; then
	  path="."
	fi

	FILES=$(find $path -name "$fname*" | egrep "h$|cpp$|hpp$|sh$|rb$" | sort -r )
	if [ "$FILES" == "" ]; then
		FILES=$fname
	fi

	vim $FILES
fi

#fname=$(echo $1 | sed -e 's/\.$//')
#vim $fname.h $fname.cpp


