#!/bin/sh

LINE=15
if [ -f "$2" ]; then
    LINE=$1
    shift
fi

FILE=$1
egrep -n "#|src|signo|\(LWP" $FILE | grep -A $LINE signo > temp.sum
grep -n -A2 "======= DPE PSTACK DUMP SERVICE =======" $FILE >> temp.sum

sort -g temp.sum

rm -rf temp.sum


