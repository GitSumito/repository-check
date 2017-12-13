#!/bin/sh

SERVERNAME=$1
TARGETFILE='
/var/spool/cron
/etc/sysconfig
/etc/logrotate.d
/etc/ntp.conf
/etc/pam_ldap.conf
/etc/resolv.conf
/etc/rsyslog.conf
/etc/sysctl.conf
'

if [[ ! -e $SERVERNAME ]]; then
        mkdir $SERVERNAME
fi

for TARGETFILE in $TARGETFILE; do
        SUBDIR=$(echo "."$TARGETFILE | sed -e "s/`echo $TARGETFILE | awk -F'/' '{print $NF}'`//g")
        echo $SERVERNAME/$SUBDIR

        if [[ ! -e $SUBDIR ]]; then
                echo "make dir $SERVERNAME/$SUBDIR"
                mkdir -p $SERVERNAME/$SUBDIR
        fi

        echo "transfer $TARGETFILE..."
        scp -pr $SERVERNAME:$TARGETFILE ./$SERVERNAME/$SUBDIR/.
done
