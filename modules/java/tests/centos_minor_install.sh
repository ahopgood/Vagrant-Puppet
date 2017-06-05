#! /usr/bin/env bash

version=$0
minorVersion=$1

#sudo puppet apply --execute "java{"java-$version:\
#version => '$version', \
#update_version => '$minorVersion',\
#}"

#Validation check
FOUND_VERSION=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')

if [ "$FOUND_VERSION" == "1.$version.0_$minorVersion" ]; then
  echo "$FOUND_VERSION Installed correctly"
  return=0;
else
  echo "Found version $FOUND_VERSION does not match desired version 1.$version.0_$minorVersion"
  return=-1;
fi