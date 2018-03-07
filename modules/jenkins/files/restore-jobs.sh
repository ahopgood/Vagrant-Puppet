#!/usr/bin/env bash
function restore_job(){
	print "Restoring job $(basename ${2}) to ${1}" 
	tar -xzf "${2}" -C ${1}
}

function print(){
        PURPLE='\033[1;35m'
        NOCOLOUR='\033[0m'
        echo -e "${PURPLE}$PREFIX ${NOCOLOUR}$1"
}

PREFIX="$0"

if [ -z $1 ];then
	print "Please provide the source directory of the backup archive"
	exit -1
fi
if [ ! -d $1 ];then
	print "The archive source is not a directory"
	exit -1
fi

BACKUP=$1
TEMP=${BACKUP}temp/
if [ -z $2 ]; then
	RESTORE_TO="/var/lib/jenkins/jobs/"
else
	RESTORE_TO=$2
fi
#Find the archives in date order and select the most recent.

print "Selecting the most recent archives in ${BACKUP}"
FOUND=$(find ${BACKUP} -name *.tar.gz -type f | tail -n1)
print "Found archive ${FOUND}"
print "Creating TEMP directory ${TEMP}"
mkdir ${TEMP}
chmod 777 ${TEMP}
tar -zxf ${FOUND} -C ${TEMP}
chmod 777 -R ${TEMP}

while read -r job_archive
do
	print "Restoring job ${job_archive}"
	restore_job ${RESTORE_TO} ${job_archive}
done < <(find ${TEMP} -type f -name *.tar.gz)

print "Removing TEMP directory ${TEMP}"
rm -rf ${TEMP}
