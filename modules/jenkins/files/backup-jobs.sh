#!/usr/bin/env bash
function backup_job(){
	PREFIX="$0:${FUNCNAME[0]}"
	print "In backup-job function"
	print "[$1] is the backup folder"
	print "[$2] is the jobs folder"
	print "[$3] is the job name"
	FULLPATH="$1$3/"

	tar -C "$2" -czf "$1${3%/}.tar.gz" \
	"$3/nextBuildNumber" \
	"$3/builds" \
	"$3/lastStable" \
	"$3/lastSuccessful"
	print "Attempting to create archive $1${3%/}.tar.gz"
}

function print(){
	PURPLE='\033[1;35m'
	NOCOLOUR='\033[0m'
	echo -e "${PURPLE}$PREFIX ${NOCOLOUR}$1"
}

PREFIX="$0"
if [ -z $1 ];then
	print "Please pass a backup location as the first parameter"
	exit -1 
elif [ ! -d $1 ];then
	print "Please pass a backup location that is a directory as the first parameter"
	exit -1
fi

if [ ! -z $2 ];then
	if [ ! -d $2 ];then
		print "Please pass a jobs location that is a directory as the second parameter"
		exit -1
	fi
	JOB_HOME=$2
else
	JOB_HOME="/var/lib/jenkins/jobs/"
fi
BACKUP=$1
print "In backup-jobs.sh"

JOBS=""
while read -r job_name
do
	print "Backing up ${job_name}"
	backup_job "${BACKUP}" "${JOB_HOME}" "${job_name#${JOB_HOME}}"
	JOBS="${JOBS}${job_name#${JOB_HOME}}.tar.gz "
done < <(find ${JOB_HOME}* -maxdepth 0 -type d)

DATE=$(date +"%Y-%m-%d-%H%M%S")
print "Creating combined backup tar ${BACKUP}${DATE}.tar.gz"
tar -C ${BACKUP} -czf "${BACKUP}${DATE}.tar.gz" ${JOBS}

JOBARRAY=(${JOBS})
for index in ${!JOBARRAY[*]} 
do
	print "Removing temp archive ${BACKUP}${JOBARRAY[index]}"
	rm "${BACKUP}${JOBARRAY[index]}"
done

