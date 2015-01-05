#!/bin/bash

if [ "$1" == "" ] ; then
    echo "Description : $0 [Device] [delay]"
    echo "          ex) $0 eth0 3 "
    exit 1
fi

      if [ "$2" == "" ] ; then
           delay=3 ; else
           delay=$2 ;
      fi

      echo "  TIME   : IN(Kbit/Sec) / OUT(Kbit/Sec) /  IN(bit/Sec)  / OUT(bit/Sec)"


      rx1=`grep $1 /proc/net/dev | awk '{print $1}' | sed 's/.*://'`
      tx1=`grep $1 /proc/net/dev | awk '{print $9}'`
      sleep $delay

      rx2=`grep $1 /proc/net/dev | awk '{print $1}' | sed 's/.*://'`
      tx2=`grep $1 /proc/net/dev | awk '{print $9}'`

      # 1024/8 == 128 
      rx3=$(((rx2-rx1)/128/delay))
      tx3=$(((tx2-tx1)/128/delay))

      rx4=$(((rx2-rx1)/128*1024/delay))
      tx4=$(((tx2-tx1)/128*1024/delay))

#      float rx5=$(((rx2-rx1)/128/1024/delay))
#      float tx5=$(((rx2-rx1)/128/1024/delay))
     echo "`date '+%k:%M:%S'` :       $rx3             $tx3            $rx4           $tx4             $rx5         $tx5"

