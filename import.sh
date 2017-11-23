#!/bin/bash

userdir=`pwd`
cd  $(cd `dirname $0`; pwd)
source conf
if [ "${1}" = "" ]; then
  echo please usege ${0} filename 
  exit 0
fi
sfile=$userdir/${1}
count=`wc -l ${sfile} | awk '{print $1}'`
cd ${userdir}
if [ ${count} -gt 0 ] && [ ${line} -gt 0 ]; then
    if [ ! -d "${dirname}" ]; then  
	mkdir "${dirname}"
        cd ${dirname}
        mkdir "logs"
    else
         echo "${dirname} directory already exists"
         echo "you want delete [${dirname}] and rebuild ? y/n " 
         read ans
         if [ "${ans}" = "n" ]; then         
	 exit 0
         else
         cd ${dirname}
	 rm -rf ./*
         mkdir "logs"
         fi   
         
    fi 
    echo spliting ...    
    split -l ${line} ${sfile} -d -a 4 ${1}_
    echo split complate
      
    echo importing 
    if [  "${shellPath}" != "" ]; then
       for file in ./*
        do
            if test -f $file
            then
            echo importing nohup $file
            nohup ${shellPath} -u${user} -p${pass} ${dbname} < $file >> ./logs/${file}_${logfile} 2>&1 &
            echo nohup complate
            fi
        done
     fi
     echo import done ! 
fi

exit 0
