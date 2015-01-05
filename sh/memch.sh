#!/bin/sh

#if [ "$#" < "3" ]; then
#    echo "[USEAGE] $0 File Func var"
#    echo "[USEAGE] $0 -d File Func var"
#    exit
#fi

IS_FULL_PRT=0
if [ "$1" == "-d" ]; then
    IS_FULL_PRT=1
    shift
fi

FILE=$1

if [ "$3" == "" ]; then
  FUNC="."
  VAR="\<$2\>"
  VAR_ORIG=$2
else
  FUNC="\<$2\>"
  VAR="\<$3\>"
  VAR_ORIG=$3
fi

P_STR="[a-zA-Z][a-zA-Z0-9_]*"
P_TYPE="$P_STR[*&]?"
P_CPP_FUNC="^$P_TYPE[[:blank:]]+$P_STR::$P_STR[[:blank:]]*\("
P_C_FUNC="^$P_TYPE[[:blank:]]+$P_STR[[:blank:]]*\("
P_CPP_DES="^$P_STR::\~$P_STR[[:blank:]]*\("
P_CPP_CONS="^$P_STR::$P_STR[[:blank:]]*\("

P_C_STX="return|continue|break|try|catch|if|else|while|for|do|case|switch|default|/\*|\*/"
#echo "$P_C_FUNC|$P_CPP_FUNC"

PRE=
egrep -n "$P_C_FUNC|$P_CPP_FUNC|$P_CPP_DES" $FILE | egrep -A 1 $FUNC |(
#egrep -n "$P_C_FUNC|$P_CPP_FUNC|$P_CPP_DES" $FILE |(
while read Line1
do
	if [ "$PRE" == "" ]; then
	  PRE=$Line1
      read Line1
	fi
   
    SI=${PRE%%:*}
    EI=${Line1%%:*} 

    if [ "$EI" == "" ]; then
        EI=$(wc -l $FILE | awk '{print $1}')
    fi
    #EI=$((EI-SI))
    #echo "$SI $EI"

	echo "$PRE"
if [ "$IS_FULL_PRT" == "0" ]; then
    #cat -n $FILE | sed -n "$SI,${EI}p" | egrep "$P_C_STX|\{|\}|$VAR" | egrep --color -A10 -B10 "$VAR|return" 
    cat -n $FILE | sed -n "$SI,${EI}p" | egrep "$P_C_STX|\{|\}|$VAR" | egrep --color -A10 -B10 "$VAR" 
else
    cat -n $FILE | sed -n "$SI,${EI}p" | egrep "$P_C_STX|\{|\}|$VAR" | sed -e "s/return/[36mreturn[0m/" -e "s/$VAR_ORIG/[0;31m$VAR_ORIG[0m/"
fi

	PRE=$Line1
done
)
