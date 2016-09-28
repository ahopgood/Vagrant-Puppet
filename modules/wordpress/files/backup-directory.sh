#!/bin/bash


#Check we are being run within the directory?

#Function to perform a backup from a base directory for the specified child directory names to a designated backup directory. 
function backup(){
#Input Sanitisation
	#First arg should be the backup path which is a directory
	if [ ! -z $1 ];then
	  BACKUP_PATH=$1
	  echo "We are attempting to backup to the following destination directory [$BACKUP_PATH]"
	  if [ ! -d $BACKUP_PATH ];then
	    echo "Backup path [$BACKUP_PATH] doesn't exist, aborting"
	    exit 1
	  fi 
	else 
	  echo "The backup path is null, aborting"
	  exit 1
	fi
	
	#Second arg should be the parent directory of the directory we wish to backup
	if [ ! -z $2 ];then
	  echo "We are attempting to use the parent directory with name [$2]"
	  PARENT_DIR=$2
	  
	  if [ ! -d $PARENT_DIR ]; then
	    echo "The parent directory for back up [$PARENT_DIR] doesn't exist, aborting"
	    exit 1
	  fi
	else 
	  echo "The parent directory is null, aborting"
	  exit 1
	fi
		 
	#Third arg should be the folder name to backup
	if [ ! -z $3 ];then
	  echo "We are attempting to backup the directory with name [$3]"
	  DIR_NAME=$3
	  
	  if [ ! -d "$PARENT_DIR$DIR_NAME" ]; then
	    echo "The directory to back up [$PARENT_DIR][$DIR_NAME] doesn't exist, attempting to treat it as a file..."
	    if [ ! -f "$PARENT_DIR$DIR_NAME" ];then
	      echo "The file to backup [$PARENT_DIR][$DIR_NAME], doesn't exist aborting"
	      exit 1
	    fi
	  fi
	else 
	  echo "The directory to back up is null, aborting"
	  exit 1
	fi

	ARCHIVE_NAME=$DIR_NAME".tar"
	COMPRESSED_ARCHIVE_NAME=$ARCHIVE_NAME".gz"
	
	CHECKSUM_FILE="checksum.txt"
	
	echo "Running compression on $DIR_NAME"
	
	tar -cf $ARCHIVE_NAME $DIR_NAME
	
	# Create compressed archive without modified data (-n) to allow for md5sum comparison disregarding modified timestamps.
	# Need to allow gzip to continue if a gzipped tar already exists in the folder hence use of --force
	gzip -n --force $ARCHIVE_NAME 
	
	
	# Does a file with the name already exist in $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME?
	if [ -f $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME ]; then
	  echo "Backup found! Checking for changes..."
	  echo "Moving into $BACKUP_PATH"
	  if [ -d $BACKUP_PATH ]; then
	    cd $BACKUP_PATH
	 
	    echo "Creating checksum file "$(pwd)"/"$CHECKSUM_FILE
	    md5sum $COMPRESSED_ARCHIVE_NAME > $CHECKSUM_FILE
	
	    echo "Moving back to plugin dir "$PARENT_DIR
	    if [ -d $PARENT_DIR  ]; then 
	      cd $PARENT_DIR
	      echo "Checking md5sum against backup file"
	      md5sum --status -c $BACKUP_PATH$CHECKSUM_FILE
		  #If ok then don't backup
		  if [ $? -eq 0 ]; then
		    echo "MD5 checksums match! Not proceeding with backup"
		  else
		    echo "Checksum different, proceeding with backup"
		    
		    # If md5sum does not match then rm backed up archive and mv new archive to backup directory
		    echo "Removing old backup $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME backed up at "$(ls -l --time-style=full-iso $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME | awk '{ print $6 " " $7 }') 
	  	    rm $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME
	    	
	    	echo "Replacing with new backup $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME"
	    	mv $COMPRESSED_ARCHIVE_NAME $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME
		  fi #end checksum status check
	
	      echo "Removing checksum file"
	      rm $BACKUP_PATH$CHECKSUM_FILE
	    else
	      echo "Cannot find directory [$PARENT_DIR] failed to proceed with checksum verification, abandoning backup process."
	      exit 1
	    fi #end dir check
	  else
	    echo "Unable to find backup destination directory [$BACKUP_PATH] abandoning backup process."
	    exit 1
	  fi #end backup path check
	else 
	  #No existing backup, this is our first so copy across the gzipped tar file.
	  echo "No backup found for "$BACKUP_PATH$DIR_NAME" proceeding with backup"
	  mv $COMPRESSED_ARCHIVE_NAME $BACKUP_PATH$COMPRESSED_ARCHIVE_NAME
	  echo "Backup done: [$BACKUP_PATH$COMPRESSED_ARCHIVE_NAME]" 
	fi
} #close function backup()


#If a directory name to back up from isn't provided then assume standard input is providing a list of directories
if [ -z $3 ]; then 
	while read line
	do
		backup $1 $2 $line
	done < /dev/stdin
else 
	backup $1 $2 $3
fi
