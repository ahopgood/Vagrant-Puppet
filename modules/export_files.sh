#!/usr/bin/env bash

# This script is for copying the .rpm and .deb installer files from the puppet modules to a specified directory.
# Makes use of the 'find' command to scour the modules/{module_name}/files/{os}/{version}/ directory structure


#$1 is the location to copy to
if [ -z "$1" -o ! -d "$1" ]; then
	echo "Search directory [$1] is null or doesn't exist, please enter a search directory"
	exit 1
#elif [ -z "$2" -o ! -d "$2" ]; then
#	echo "Target directory [$2] is null or doesn't exist, please enter a target directory"
#	exit 1
else
	#echo "Searching directory $1"
	echo "Transferring to target directory $1"
	find . \( -name '*.deb' -o -name '*.rpm' -o -name '*.tar.gz' \) -exec cp --parents {\} "$1" \;
fi
