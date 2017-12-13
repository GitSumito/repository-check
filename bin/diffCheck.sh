#!/bin/sh
SERVERNAME=$1
configFile=$2
GitPath=`grep ^PATH $2 | awk '{print $2}'`
Net_x=`grep ^$SERVERNAME $2 | awk '{print $2}'`

FILESIZE=30
ARRAY1=()

for filename in `find ../../$GitPath/$Net_x/$SERVERNAME -type f -size -${FILESIZE}k | sed "s/^.\/$SERVERNAME//g"` ;do

        #echo $filename;
        remoteFilename=`echo $filename | awk -F $SERVERNAME '{print $2}'`

        #echo "# local-checking... $filename "
        #echo "# remote-checking... $remoteFilename "
        ssh $SERVERNAME "sudo cat $remoteFilename" | sudo diff - $filename ;

        if [ $? -ne 0 ] ;then
                echo "DAMEDATTA ****************** NG *****************************"
                ARRAY1=("${ARRAY1[@]}" "$filename")
        fi
done

echo "---------------------------------------------------------"
echo "                      REPORT"
echo "---------------------------------------------------------"

# notice skipped files.
echo "# SKIPPED (due to over ${FILESIZE} KByte)"
for filename in `find ../../$GitPath/$Net_x/$SERVERNAME -type f -size +${FILESIZE}k | sed "s/^.\/$SERVERNAME//g"` ;do
        remoteFilename=`echo $filename | awk -F $SERVERNAME '{print $2}'`
        echo " $remoteFilename"
done
echo "---------------------------------------------------------"

# Checked files.
echo "# CHECKED"
for filename in `find ../../$GitPath/$Net_x/$SERVERNAME -type f -size -${FILESIZE}k | sed "s/^.\/$SERVERNAME//g"` ;do
        remoteFilename=`echo $filename | awk -F $SERVERNAME '{print $2}'`
        echo " $remoteFilename"
done
echo "---------------------------------------------------------"

# notice differrences if it existed
if [ "${#ARRAY1[@]}"  -eq 0 ] ;then
        echo "no differrences. (except for skipped files.) "
else
        echo "                      differrences"
        echo "---------------------------------------------------------"
        echo please check these files.
        i=0
        for e in ${ARRAY1[@]}; do
            echo " ${e}"
            let i++
        done
fi
