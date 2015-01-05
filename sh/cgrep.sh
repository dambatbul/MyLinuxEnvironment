#! /bin/sh
# grep str and c or c++ function

DETAIL=0
if [ "$1" == "-d" ]; then
    DETAIL=1
    shift
fi

EXACT=0
if [ "$1" == "-e" ]; then
	EXACT=1
    shift
fi

if [ "$1" == "" ]; then
    echo "[USEAGE]$0 str source_files"
    exit
fi

STR=$1
shift


P_BK="[[:blank:]]"
P_STR="[a-zA-Z][a-zA-Z0-9_]*"
P_NUM="[0-9][0-9]*"
P_TYPE="$P_STR$P_BK*[*&]?"

#P_CPP_FUNC="^$P_TYPE$P_BK+$P_STR::$P_STR$P_BK*\("
#P_C_FUNC="^$P_TYPE$P_BK+$P_STR$P_BK*\("
#P_CPP_CONS="$P_STR::$P_STR$P_BK*\("

P_CPP_DES="$P_STR::\~$P_STR$P_BK*\([^;]*$"
P_CPP_FUNC="$P_STR::$P_STR$P_BK*\([^;]*$"
P_C_FUNC="^[^#]*$P_STR$P_BK*\([^;]*$"
#echo "$P_C_FUNC|$P_CPP_FUNC"
#echo $P_CPP_CONS
P_PRE="$P_NUM:"

if [ "$EXACT" == "1" ]; then
	STR="[^a-zA-Z0-9_]$STR[^a-zA-Z0-9_]"
fi

for File in $*
do
    Class=${File##*/}
    Class=${Class%.*}

    if [ "$DETAIL" == "1" ]; then
        egrep -n "$STR" $File > temp.cgrep 
    else
        egrep -n "$STR" $File | egrep -v "$P_PRE$P_BK*//|AREA_|PRINT|CHECK_POINTER|LOG" > temp.cgrep
    fi

    if [ -s temp.cgrep ]; then
        echo "$Class ------------------------------------"
        echo $File
        egrep -n "$P_C_FUNC|$P_CPP_FUNC|$P_CPP_DES" $File | egrep -v "$P_BK+if[ (]|$P_BK+while[ (]|$P_BK+switch[ (]" >> temp.cgrep
        sort -g temp.cgrep | egrep --color -B 1 "$STR"
        echo
    fi
done
rm -rf temp.cgrep

