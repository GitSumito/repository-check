#!/bin/sh

validateCheck="";
if [ $# -ne 1 ]; then
  echo "Please execute one of these commands" 1>&2
  echo "----------------------------------" 1>&2

  for configName in `ls config`; do
	echo "./check.sh $configName"
  done 
  echo "----------------------------------" 1>&2
  exit 1

else 
  for configName in `ls config`; do
        if [ "$configName" = "$1" ]; then
		validateCheck=OK;
	fi
  done
fi

if [ "$validateCheck" != "OK" ] ; then
  echo "Please check config file name";
  exit 1;
fi

configFileName=config/$1
workdir=`date +%Y%m%d-%H%M%S`_work; [ ! -e $workdir ] && mkdir -p $workdir

touch $workdir/$target
touch $workdir/survey

for target in `cat $configFileName | grep -v PATH | awk {'print $1'}` ; do
	echo $target;
	
	if [ "FWF" = `echo $target | cut -c3-5` ] ; then
		sh ./bin/diffCheckFW.sh $target $configFileName> $workdir/$target
        elif [ "FWB" = `echo $target | cut -c4-6` ] ; then
		sh ./bin/diffCheckFW.sh $target $configFileName> $workdir/$target
	else
		sh ./bin/diffCheck.sh $target $configFileName> $workdir/$target
	fi
done


for target in `ls $workdir` ; do
	differences=`grep differrences -A 10 $workdir/$target | awk -F "$target" '{print $2}' | grep -v '^\s*#' |grep -v '^\s*$'` 

	if [ `grep differrences -A 10 $workdir/$target | awk -F "$target" '{print $2}' | grep -v '^\s*#' |grep -v '^\s*$' | wc -l` -gt 0 ] ; then
		echo "$target" >> $workdir/survey
		echo "$differences" >> $workdir/survey
		echo "" >> $workdir/survey
	fi
done


if [ `cat $workdir/survey | wc -l ` -gt 0 ] ; then
	echo "warning! repository difference happened! Please refer to /var/log/repository/repository " > /var/log/repository/repository
	echo "--------------------" >> /var/log/repository/repository
	cat "$workdir/survey" >> /var/log/repository/repository
else
	echo "OK!!! no difference!!" > /var/log/repository/repository
fi


# clean up
find -name "2017*work" -type d -mtime +2 -exec rm -rf {} \;
