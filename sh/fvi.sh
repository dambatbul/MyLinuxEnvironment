#! /bin/sh

HIS=~/.fvi_history

if [ "$1" == ""  ]; then
	echo "[USAGE] fvi filename:"
	#cat -n $HIS | awk '{if($2=="fvi"&&$3!="")print $3}' | awk '!/[[:digit:]*]/{print $1}' | sort | uniq | cat -n
	sort -u $HIS | cat -n
	exit
fi

if [ "$1" == "clean" ]; then
	cat /dev/null > $HIS
	exit
fi

FILE=
if [ -z $(echo $1 | sed -e 's/[0-9]//g') ]; then
	#FILE=$(cat -n $HIS | awk '{if($2=="fvi"&&$3!="")print $3}' | awk '!/[[:digit:]*]/{print $1}' | sort | uniq | sed -n "$1,$1p")
	FILE=$(sort -u $HIS | sed -n "$1,$1p")
else
	FILE=$1
fi

FILES=$(find . -type f -name "$FILE" | egrep -v "svn-base$|Po$|o$" | sort -r)
if [ "$FILES" == "" ]; then
	echo "[error]can't find $FILE"
	sort -u $HIS | cat -n | grep $FILE
else
	echo "$FILE" >> $HIS
	vim $FILES 
fi

