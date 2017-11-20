#!/bin/bash

PREFIX="[$0]"

PLUGIN_NAME=$1
if [ -z $1 ]; then
  echo "${PREFIX} A plugin name is required as the first parameter"
  exit 1
fi


VERSION="LATEST"
if [ -z $2 ]; then
  echo "${PREFIX} No plugin version provided, using ${VERSION} version"
  JENKINS_PLUGIN_URL="https://updates.jenkins.io/latest/"
  PLUGIN_HOME="${JENKINS_PLUGIN_URL}"
  echo "${PREFIX} Using plugin home [${PLUGIN_HOME}]"
  PLUGIN_LINK_NAME="${PLUGIN_NAME}"
else
  VERSION=$2
  echo "${PREFIX} Trying to retrieve plugin version ${VERSION}"
  JENKINS_PLUGIN_URL="https://updates.jenkins.io/download/plugins/"
  PLUGIN_HOME="${JENKINS_PLUGIN_URL}${PLUGIN_NAME}/"
  echo "${PREFIX} Using plugin home [${PLUGIN_HOME}]"
  PLUGIN_LINK_NAME="${PLUGIN_NAME}/${VERSION}/${PLUGIN_NAME}"
fi
DOWNLOAD_TO="."
if [ ! -z $3 ]; then
  DOWNLOAD_TO=$3
fi

echo "${PREFIX} Downloading plugin [${PLUGIN_NAME}] [${VERSION}] to [${DOWNLOAD_TO}]"

# Note extension could be either .hpi or .jpi
# Add check to ensure that .hpi or .jpi extension exists in plugin name, forcing that decision to the user?
#PLUGIN_HOME="${JENKINS_PLUGIN_URL}${PLUGIN_NAME}/"
#VERSIONED="https://updates.jenkins.io/download/plugins/AnchorChain/1.0/AnchorChain.hpi"
#LATEST="https://updates.jenkins.io/latest/AnchorChain.hpi"

if [ ! -z ${VERSION} ]; then
  curl -X GET ${PLUGIN_HOME} | grep "${PLUGIN_LINK_NAME}.hpi"
  if [ $? == 0 ]; then
    echo "${PREFIX} Found .hpi extension"
    EXTENSION=".hpi"
  else
    curl -X GET ${PLUGIN_HOME} | grep "${PLUGIN_LINK_NAME}.jpi"
    if [ $? == 0 ];then
      echo "${PREFIX} Found .jpi extension"
      EXTENSION=".jpi"
    else
      echo "${PREFIX} Extension type is not supported, only .hpi or .jpi allowed"
      exit 1
    fi # end jpi check
  fi # end hpi
  RETRIEVE_URL="${JENKINS_PLUGIN_URL}${PLUGIN_LINK_NAME}${EXTENSION}"
  cd ${DOWNLOAD_TO}
  echo "${PREFIX} Using plugin retrieval url ${RETRIEVE_URL}"
  wget -N ${RETRIEVE_URL}
  #wget -N will check timestamps to ensure we only pull down newer files, possibly useful instead of using hashes which require a download to verify
fi

# 1. No plugin name - fail
# 2. No version - download latest version
# 3. No download location - download to current directory
# 4. Version provided - download specific version
# 5. Version provided and version is malformed/doesn't exist - fail
# 6. Plugin name provided and is malformed/doesn't exist - fail
# 7. Plugin name & version provided - download specific version