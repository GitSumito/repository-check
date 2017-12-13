#!/bin/sh
SERVERNAME=$1
configFile=$2
GitPath=`grep ^PATH $2 | awk '{print $2}'`
Net_x=`grep ^$SERVERNAME $2 | awk '{print $2}'`

ARRAY1=()

ssh $SERVERNAME '~/run-command.sh show configuration commands' |  diff - ../../$GitPath/$Net_x/$SERVERNAME/show_configuration_commands

if [ $? -ne 0 ] ;then
        echo "DAMEDATTA ****************** NG *****************************"
        ARRAY1=("${ARRAY1[@]}" "$filename")
fi

echo "---------------------------------------------------------"


if [ "${#ARRAY1[@]}"  -eq 0 ] ;then
        echo "no differrences. "
else
        echo "                      differrences"
        echo "---------------------------------------------------------"
        echo "$SERVERNAME show_configuration_commands"
fi
