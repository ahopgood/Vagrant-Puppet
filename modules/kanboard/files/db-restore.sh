#!/bin/bash

### Restore ###
#Find all diff files by pattern matching the name. Select the first arg, grep to match again, not sure why, then select the last value.
#< $(find . -name '*-kanboardbackup.sql.diff'|awk '{print $1}'|grep \kanboardbackup|tail -1)

#Pipe the above into patch with a find all with name matching the first back up file.
#patch $(find . -name '*-kanboardbackup.sql'|awk '{print $1}'|head -1)

#Original
#patch $(find . -name '*-kanboardbackup.sql'|awk '{print $1}'|head -1) < $(find . -name '*-kanboardbackup.sql.diff'|awk '{print $1}'|grep \kanboardbackup|tail -1)
#Revised
#Create a single diff file

#cat ${backup_path}*-kanboardbackup.sql.diff > ${backup_path}compiled-kanboardbackup.sql.diff
cat /vagrant/files/backups/*-kanboardbackup.sql.diff > /vagrant/files/backups/compiled-kanboardbackup.sql.diff

#Apply the diff file to the first backup.sql
#patch $(find . -name '*-kanboardbackup.sql'|head -1) < $(find . -name '*-kanboardbackup.sql.diff'|tail -1)

#patch $(find . -name '*-kanboardbackup.sql'|head -1) -b < ${backup_path}compiled-kanboardbackup.sql.diff

cp $(find /vagrant/files/backups/ -name '*-kanboardbackup.sql'|head -1) $(/bin/date +%Y-%m-%d-%H-%M)-kanboard-restore.sql

patch $(find . -name '*-kanboard-restore.sql'|head -1) < /vagrant/files/backups/compiled-kanboardbackup.sql.diff
