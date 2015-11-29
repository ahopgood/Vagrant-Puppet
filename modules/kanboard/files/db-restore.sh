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

#patch $(find . -name '*-kanboardbackup.sql'|head -1) < $(find . -name '*-kanboardbackup.sql.diff'|tail -1)
#patch $(find . -name '*-kanboardbackup.sql'|head -1) -b < ${backup_path}compiled-kanboardbackup.sql.diff
#cat ${backup_path}*-kanboardbackup.sql.diff > ${backup_path}compiled-kanboardbackup.sql.diff

#!/bin/bash

### Restore ###
#Create a concatenated diff file of all the diff files.

cat /vagrant/files/backups/*-kanboardbackup.sql.diff > /vagrant/files/backups/compiled-backup.sql.diff

#Copy the original db dump script to work on
cp $(find /vagrant/files/backups/ -name '*-kanboardbackup.sql'|head -1) $(/vagrant/files/backups/$(/bin/date +%Y-%m-%d-%H-%M)-kanboard-restore.sql)

#Apply the diff file to the copy of the first db dump script
patch $(find /vagrant/files/backups/ -name '*-kanboard-restore.sql'|head -1) < /vagrant/files/backups/compiled-kanboardbackup.sql.diff
