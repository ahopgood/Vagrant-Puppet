#!/bin/bash


#Check we are being run within the directory?

#Function to perform a backup from a base directory for the specified child directory names to a designated backup directory. 
function restore(){
#Input Sanitisation
	#First arg should be the parent directory of the directory we wish to restore to
	if [ ! -z $1 ];then
	  PARENT_DIR=$1
	  echo "We are attempting to restore to the parent directory with name [$PARENT_DIR]"
	  	  	  
	  if [ ! -d $PARENT_DIR ]; then
	    echo "The parent directory to restore to [$PARENT_DIR] doesn't exist, aborting"
	    exit 1
	  fi
	else 
	  echo "The parent directory to restore to is null, aborting"
	  exit 1
	fi
	
	#Second arg should be the backup path which is a directory 	
	if [ ! -z $2 ];then
	  BACKUP_PATH=$2
	  echo "We are attempting to restore from the following backed up directory [$BACKUP_PATH]"
	  if [ ! -d $BACKUP_PATH ];then
	    echo "Restore path [$BACKUP_PATH] doesn't exist, aborting"
	    exit 1
	  fi 
	else 
	  echo "The path to restore from is null, aborting"
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
	/usr/bin/cd $BACKUP_PATH
	TEMP_DIR=$BACKUP_PATH"tmp"
	if [ ! -d $TEMP_DIR ]; then
		echo "Creating temp directory [$TEMP_DIR]"
		mkdir $TEMP_DIR
	fi
	
	echo "Moving into tmp directory"
	/usr/bin/cd $TEMP_DIR
	
	echo "Decompressing archive $BACKUP_PATH$DIR_NAME"
	tar zxvf $BACKUP_PATH$DIR_NAME
	ls -l $TEMP_DIR
	
	#If plugin folder or file exists then don't restore
	EXPANDED_PLUGIN=$(ls -1 | head -n 1)
	#If there is more than one element in the directory we have problems
	
	echo $EXPANDED_PLUGIN
	
	echo "Contents of the temp dir [$TEMP_DIR]"
	ls -1 $TEMP_DIR
			
	EXIT_STATUS=0
	if [ ! -e "$PARENT_DIR$EXPANDED_PLUGIN" ]; then
		echo $PARENT_DIR$EXPANDED_PLUGIN" does not exist"  
		echo "Moving $EXPANDED_PLUGIN to $PARENT_DIR" 
		mv $TEMP_DIR/$EXPANDED_PLUGIN $PARENT_DIR
	else
		#Create md5sum file of the folder contents for the plugin 
		echo "Creating md5sum of decompressed archive"
		find $EXPANDED_PLUGIN -type f -print0 | xargs -0 md5sum > $BACKUP_PATH$EXPANDED_PLUGIN"_md5sum.txt"

		#Check the md5sum of the current plugin against the newly expanded folder
		echo "$PARENT_DIR$EXPANDED_PLUGIN already exists, checking contents"
		cd $PARENT_DIR
		echo "Moving into "$PARENT_DIR
		md5sum -c $BACKUP_PATH$EXPANDED_PLUGIN"_md5sum.txt"
		
		if [ $? != 0 ]; then
	        echo "md5sum of "$DIR_NAME" is different, removing old plugin $PARENT_DIR$EXPANDED_PLUGIN"
	        rm -rf $PARENT_DIR$EXPANDED_PLUGIN
	        echo "Moving $EXPANDED_PLUGIN to $PARENT_DIR" 
			mv $TEMP_DIR/$EXPANDED_PLUGIN $PARENT_DIR
	    else
	    	echo "md5sum is a match, plugin is up to date" 
			echo "Removing temporary expanded plugin [$TEMP_DIR/$EXPANDED_PLUGIN]"
			rm -rf $TEMP_DIR/$EXPANDED_PLUGIN
	    fi
	    echo "Removing md5sum file: "$BACKUP_PATH$EXPANDED_PLUGIN"_md5sum.txt"
	    rm $BACKUP_PATH$EXPANDED_PLUGIN"_md5sum.txt"
	fi
	
#	echo "Removing temporary directory [$TEMP_DIR]"
#	cd ../
#	rm -rf $TEMP_DIR
	

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
