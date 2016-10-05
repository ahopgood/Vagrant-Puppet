#!/bin/bash


#Check we are being run within the directory?

#Function to perform a backup from a base directory for the specified child directory names to a designated backup directory. 
function restore(){
#Input Sanitisation
	#First arg should be the backup path which is a directory
	if [ ! -z $1 ];then
	  BACKUP_PATH=$1
	  echo "We are attempting to restore from the following backed up directory [$BACKUP_PATH]"
	  if [ ! -d $BACKUP_PATH ];then
	    echo "Restore path [$BACKUP_PATH] doesn't exist, aborting"
	    exit 1
	  fi 
	else 
	  echo "The path to restore from is null, aborting"
	  exit 1
	fi
	
	#Second arg should be the parent directory of the directory we wish to restore to
	if [ ! -z $2 ];then
	  echo "We are attempting to restore to the parent directory with name [$2]"
	  PARENT_DIR=$2
	  
	  if [ ! -d $PARENT_DIR ]; then
	    echo "The parent directory to restore to [$PARENT_DIR] doesn't exist, aborting"
	    exit 1
	  fi
	else 
	  echo "The parent directory to restore to is null, aborting"
	  exit 1
	fi
		 
	#Third arg should be the folder name to backup
	if [ ! -z $3 ];then
	  echo "We are attempting to restore the archive with name [$3]"
	  DIR_NAME=$3
	  
	  if [ ! -f "$BACKUP_PATH$DIR_NAME" ]; then
	    echo "The archive to restore [$BACKUP_PATH][$DIR_NAME] doesn't exist aborting"
	    exit 1
	  fi
	else 
	  echo "The archive to restore is null, aborting"
	  exit 1
	fi

	echo "Moving into backup directory [$BACKUP_PATH]"
	cd $BACKUP_PATH
	
	echo "Creating temp directory [$HOME/tmp]"
	mkdir ~/tmp
	
	echo "Moving into tmp directory"
	cd ~/tmp
	
	echo "Decompressing archive $BACKUP_PATH$DIR_NAME"
	tar zxvf $BACKUP_PATH$DIR_NAME

	#If plugin folder or file exists then don't restore
	EXPANDED_PLUGIN=$(ls -1)

	EXIT_STATUS=0
	if [ ! -e "$PARENT_DIR$EXPANDED_PLUGIN" ]; then
		echo "Moving $EXPANDED_PLUGIN to $PARENT_DIR" 
		mv $EXPANDED_PLUGIN $PARENT_DIR
	#	EXIT_STATUS=0  
	else
		echo "$PARENT_DIR$EXPANDED_PLUGIN already exists, aborting restore"
		echo "Removing temporary expanded plugin [$(pwd)/$EXPANDED_PLUGIN]"
		rm -rf $EXPANDED_PLUGIN
		exit 1
	fi
	
	echo "Removing temporary directory [tmp]"
	cd ../
	rm -rf tmp 
	

} #close function backup()


#If a directory name to back up from isn't provided then assume standard input is providing a list of directories
if [ -z $3 ]; then 
	while read line
	do
		echo $line
		restore $1 $2 $line
	done < /dev/stdin
else 
	restore $1 $2 $3
fi
