
#!/bin/bash

CUR_TIME=`date "+%F %T"`
MEM_DATA=`free | grep "Mem:"`
echo "$CUR_TIME      $MEM_DATA"

