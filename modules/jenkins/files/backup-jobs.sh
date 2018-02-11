#!/usr/bin/env bash
function backup_job(){
	PREFIX="$0:${FUNCNAME[0]}"
	print "In backup-job function"
	print "[$1] is the backup folder"
	print "[$2] is the jobs folder"
	print "[$3] is the job name"
	FULLPATH="$1$3/"
	mkdir "${FULLPATH}"
	cp "$2/$3/nextBuildNumber" "${FULLPATH}"
	cp -R "$2/$3/builds" "${FULLPATH}builds"
	cp -P "$2/$3/lastStable" "${FULLPATH}"
        cp -P "$2/$3/lastSuccessful" "${FULLPATH}"
	print "Attempting to create archive ${3%/}.tar.gz"
	tar -C "$1" -czf "${FULLPATH%/}.tar.gz" "$3"
}

function print(){
	PURPLE='\033[1;35m'
	NOCOLOUR='\033[0m'
	echo -e "${PURPLE}$PREFIX ${NOCOLOUR}$1"
}

PREFIX="$0"
print "In backup-jobs.sh"

#backup_job "/home/vagrant/backups/" "/var/lib/jenkins/jobs/" "jenkins-ci/" 
find /var/lib/jenkins/jobs/* -maxdepth 0 -type d |
while read job_name
do
	print "Backing up ${job_name}"
	backup_job "/home/vagrant/backups/" "/var/lib/jenkins/jobs/" "${job_name#/var/lib/jenkins/jobs/}"
done
