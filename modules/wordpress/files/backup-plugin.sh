#!/bin/bash

PLUGIN_DIR="/var/www/html/wordpress/wp-content/plugins/"
BACKUP_PATH="/vagrant/backups/"

DIR_NAME="breadcrumb-navxt"
ARCHIVE_NAME=$DIR_NAME".tar"
COMPRESSED_ARCHIVE_NAME=$ARCHIVE_NAME".gz"

CHECKSUM_FILE="checksum.txt"

echo "Running plugin compression on $DIR_NAME"


#tar -czf $COMPRESSED_ARCHIVE_NAME $DIR_NAME
tar -cf $ARCHIVE_NAME $DIR_NAME
# Create compressed archive without modified data (-n) to allow for md5sum comparison disregarding modified timestamps.
gzip -n $ARCHIVE_NAME 
#Need to allow gzip to continue if a gzipped tar already exists in the folder

# Does a file with the name already exist in $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME?
if [ -f $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME ]; then
  echo "Backup found! Checking for changes..."
  echo "Moving into $BACKUP_PATH"
  if [ -d $BACKUP_PATH ]; then
    cd $BACKUP_PATH
 
    echo "Creating checksum file "$(pwd)"/"$CHECKSUM_FILE
    md5sum $COMPRESSED_ARCHIVE_NAME > $CHECKSUM_FILE

    echo "Moving back to plugin dir "$PLUGIN_DIR
    if [ -d $PLUGIN_DIR  ]; then 
      cd $PLUGIN_DIR
      echo "Checking md5sum against backup file"
      md5sum --status -c $BACKUP_PATH$CHECKSUM_FILE
	  #If ok then don't backup
	  if [ $? -eq 0 ]; then
	    echo "MD5 checksums match! Not proceeding with backup"
	  else
	    echo "Checksum different, proceeding with backup"
	    
	    #If md5sum does not match then rm backed up archive then mv new archive to backup directory
	    echo "Removing old backup $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME backed up at "$(ls -l --time-style=full-iso $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME | awk '{ print $6 " " $7 }') 
  	    rm $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME
    	
    	echo "Replacing with new backup $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME"
    	mv $COMPRESSED_ARCHIVE_NAME $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME
	  fi #end checksum status check

      echo "Removing checksum file"
      rm $BACKUP_PATH$CHECKSUM_FILE
    else
      echo "Cannot find plugin directory "$PLUGIN_DIR" failed to proceed with checksum verification, abandoning backup process."
    fi #end plugin dir check
  else
    echo "Unable to find backup directory "$BACKUP_PATH" abandoning backup process."
    #return 1
  fi #end backup path check
else 
  #No existing backup, this is our first so copy across the gzipped tar file.
  echo "No backup found for "$BACKUP_PATH$DIR_NAME" proceeding with backup"
  mv $COMPRESSED_ARCHIVE_NAME $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME
  echo "Backup done: [$BACKUP_PATH$COMPRESSED_ARCHIVE_NAME]" 
fi
