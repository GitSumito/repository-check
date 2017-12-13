#!/bin/sh
SERVERNAME=$1
ConfigFileName=$2
PATH1=`grep ^PATH ../config/$ConfigFileName | awk '{print $2}'`
PATH2=`grep ^$SERVERNAME ../config/$ConfigFileName | awk '{print $2}'`

#echo "ssh $SERVERNAME '~/run-command.sh show configuration commands' > ../../../$PATH1/$PATH2/$SERVERNAME"
ssh $SERVERNAME '~/run-command.sh show configuration commands' > ../../../$PATH1/$PATH2/$SERVERNAME/show_configuration_commands

echo ../../../$PATH1/$PATH2/$SERVERNAME/show_configuration_commands
