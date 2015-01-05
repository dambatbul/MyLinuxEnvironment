
#!/bin/sh
#http://www.websequencediagrams.com/

if [ -f $1 ]; then echo
else
    echo "[Usage] $0 <file name>" 
    exit;
fi

awk 'BEGIN { RS="\n       "; ORS=""}{print $0}' $1 | egrep -n "SERVER_ROLE|METHOD_NAME|DIRECTION|From|To" | grep -v "Refer-To" | (
while read Line
do
    LineN=${Line%%:*} 

    readcnt=0
    Line=${Line#*:}
    Line=$(echo $Line | sed -e 's/^ *//' -e 's/ *$//')

    case $Line in
        SERVER_ROLE*) SERVER_ROLE=$Line;;
        METHOD_NAME*) METHOD=$Line;;
        DIRECTION*)   DIRECTION=$Line;;
        From:*)       From_Line=$Line;;
        To:*)         To_Line=$Line;; 
    esac
    
    if [ -z "$SERVER_ROLE" ] || [ -z "$METHOD" ] || [ -z "$DIRECTION" ] || [ -z "$From_Line" ] || [ -z "$To_Line" ] ; then
        continue
    fi

    SERVER_ROLE=${SERVER_ROLE#*= }
    SERVER_ROLE=${SERVER_ROLE% ?}

    METHOD=${METHOD#*= }
    METHOD=${METHOD%% *}

    Temp=${METHOD#*-}
    if [ "$Temp" == "$METHOD" ]; then
        isRequest=true
    else
        isRequest=false
    fi

    DIRECTION=${DIRECTION#*= }
    DIRECTION=${DIRECTION%% *}
    if [ "RE-SEND" == "$DIRECTION" ] || [ "RE-RECV" == "$DIRECTION" ]; then
        DIRECTION=${DIRECTION#*-}
        METHOD="RE-$METHOD"
    fi

    from_tag=${From_Line##*-}
    to_tag=${To_Line##*-}

    From=${From_Line#*tel:}
    From=${From#*sip:}
    From=${From%%;*}
    From=${From%%>*}
    From=${From%%:*}

    To=${To_Line#*tel:}
    To=${To#*sip:}
    To=${To%%;*}
    To=${To%%>*}
    To=${To%%:*}

    if [ "$isRequest" != "true" ]; then
        Temp=$From
        From=$To
        To=$Temp

        Temp=$from_tag
        from_tag=$to_tag
        to_tag=$Temp
    fi

#	 echo $SERVER_ROLE
#    echo $METHOD
#    echo $DIRECTION
#    echo $From
#    echo $To
#    echo $from_tag
#    echo $to_tag
#    echo 
#    continue

    METHOD="$METHOD ($LineN)"
    if [ "$SERVER_ROLE" == "IM ORIGINATING PARTICIPANT" ]; then
        if [ "$DIRECTION" == "RECV" ]; then
            echo "$From->OPF: $METHOD"
        else
            echo "OPF->$To: $METHOD"
        fi
    elif [ "$SERVER_ROLE" == "IM CONTROLLING" ]; then
        if [ "$DIRECTION" == "RECV" ]; then
            echo "TPF($From)->CF: $METHOD"
        else
            echo "CF->TPF($To): $METHOD"
        fi
    elif [ "$SERVER_ROLE" == "IM TERMINATING PARTICIPANT" ]; then
        if [ "$DIRECTION" == "RECV" ]; then
            if [ "$from_tag" == "cf" ]; then
                echo "CF->TPF($To): $METHOD"
            else
                echo "$From->TPF($From): $METHOD"
            fi
        else
           if [ "$to_tag" == "cf" ]; then
                echo "TPF($From)->CF: $METHOD"
           else
                echo "TPF($To)->$To: $METHOD"
           fi
        fi
        
    elif [ "$SERVER_ROLE" == "IM" ]; then
            
        if [ "$DIRECTION" == "RECV" ]; then
            echo "$From->IM: $METHOD"
        else
            echo "IM->$To: $METHOD"
        fi
    fi

    SERVER_ROLE=
    METHOD=
    DIRECTION=
    From_Line=
    To_Line=


done
)

