#!/usr/bin/env bash
echo "using backup location "$1
/usr/bin/rsync -a /var/lib/jenkins/* $1$(/bin/date +%y-%m-%d-%H%M-jenkins-backup) --exclude /var/lib/jenkins/plugins/