#! /bin/sh

#cat -n ~/.bash_history | awk '{if($2="'${1}'")print}'
#history 
var=$(history); echo "$var" 

