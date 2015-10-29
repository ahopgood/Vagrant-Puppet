#!/bin/bash

#--net_buffer_length=4096 to prevent stupidly long insert lines, which in turn create large diff files.
#Needs to be run within the backups folder.
#mysqldump --net_buffer_length=4096 -uroot -proot kanboard > /vagrant/files/backups/$(/bin/date +%Y-%m-%d-%H-%M)-kanboardbackup.sql
#diff --suppress-common-lines  $(ls /vagrant/files/backups/|awk '{print $1}'|grep \kanboardbackup|tail -2) > /vagrant/files/backups/$(/bin/date +%Y-%m-%d-%H-%M)-kanboardbackup.sql.diff

#ls | awk '{print $1}'
#This will print the contents of ls out as a list of outputs good for piping to another function.

#ls | awk '{print $1}'|grep \kanboard|tail -2
#tail -2 will return the last two elements of the list.
#or use
#ls -1 *kanboardbackup.sql* | tail -2

#Dump followed by a diff
#mysqldump --net_buffer_length=4096 -u${dbusername} -p${dbpassword} ${dbname} > ${backup_path}$(/bin/date +%Y-%m-%d-%H-%M)-kanboardbackup.sql
#diff --suppress-common-lines  $(ls -1 *kanboardbackup.sql* | tail -2) > ${backup_path}$(/bin/date +%Y-%m-%d-%H-%M)-kanboardbackup.sql.diff

 
### Restore ###
#Find all diff files by pattern matching the name. Select the first arg, grep to match again, not sure why, then select the last value.
#< $(find . -name '*-kanboardbackup.sql.diff'|awk '{print $1}'|grep \kanboardbackup|tail -1)

Pipe the above into patch with a find all with name matching the first back up file.
#patch $(find . -name '*-kanboardbackup.sql'|awk '{print $1}'|head -1)

#Original
#patch $(find . -name '*-kanboardbackup.sql'|awk '{print $1}'|head -1) < $(find . -name '*-kanboardbackup.sql.diff'|awk '{print $1}'|grep \kanboardbackup|tail -1)
#Revised
patch $(find . -name '*-kanboardbackup.sql'|head -1) < $(find . -name '*-kanboardbackup.sql.diff'|tail -1)