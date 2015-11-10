#!/bin/bash

### Restore ###
#Find all diff files by pattern matching the name. Select the first arg, grep to match again, not sure why, then select the last value.
#< $(find . -name '*-kanboardbackup.sql.diff'|awk '{print $1}'|grep \kanboardbackup|tail -1)

Pipe the above into patch with a find all with name matching the first back up file.
#patch $(find . -name '*-kanboardbackup.sql'|awk '{print $1}'|head -1)

#Original
#patch $(find . -name '*-kanboardbackup.sql'|awk '{print $1}'|head -1) < $(find . -name '*-kanboardbackup.sql.diff'|awk '{print $1}'|grep \kanboardbackup|tail -1)
#Revised
#Create a single diff file
cat *-kanboardbackup.sql.diff > compiled-kanboardbackup.sql.diff
#Apply the diff file to the first backup.sql
#patch $(find . -name '*-kanboardbackup.sql'|head -1) < $(find . -name '*-kanboardbackup.sql.diff'|tail -1)
patch $(find . -name '*-kanboardbackup.sql'|head -1) -b < compiled-kanboardbackup.sql.diff
