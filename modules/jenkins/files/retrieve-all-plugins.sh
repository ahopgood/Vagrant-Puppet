#!/bin/bash

BACKUP_LOCATION="backups/"
RESTORE_LOCATION="jenkins/"
RESTORE_SCRIPT_LOCATION="/usr/local/bin/"

PREFIX="[$0]"

BACKUP_LOCATION=$1
if [ -z $1 ]; then
  echo "${PREFIX} A backup location is required as the first parameter"
  exit 1
fi

RESTORE_LOCATION=$2
if [ -z $2 ]; then
  echo "${PREFIX} A restore location is required as the second parameter"
  exit 1
fi

cat ${BACKUP_LOCATION}plugins.txt |
while read line
do
  echo "${PREFIX} Reading plugin from file [$line]"
  PLUGIN_NAME=$(echo $line | awk -F ':' '{ print $1 }')
  PLUGIN_VERSION=$(echo $line | awk -F ':' '{ print $2 }')
  PLUGIN_HASH=$(echo $line | awk -F ':' '{ print $3 }')
  # How do we know the local version is correct?
  PLUGIN_LOCATION=$(find ${BACKUP_LOCATION} \( -name "${PLUGIN_NAME}.jpi" -o -name "${PLUGIN_NAME}.hpi" \))
  
  if [ ! -z ${PLUGIN_LOCATION} ];then
      echo "${PREFIX} Found backed up plugin [${PLUGIN_LOCATION}]"
      if [ ! -z ${PLUGIN_HASH} ];then
        echo "${PREFIX} Found hash for file [${PLUGIN_HASH}], checking now..."
        echo "${PLUGIN_HASH} ${PLUGIN_LOCATION}" > ${BACKUP_LOCATION}${PLUGIN_NAME}.md5
        md5sum --check ${BACKUP_LOCATION}${PLUGIN_NAME}.md5
        if [ $? == 0 ]; then
          echo "${PREFIX} Hash matches for ${PLUGIN_LOCATION}"
          # Does the version match? No idea! Would need to deploy and check
          rm ${BACKUP_LOCATION}${PLUGIN_NAME}.md5
          echo "${PREFIX} Restoring plugin [${PLUGIN_NAME}] from back up location [${BACKUP_LOCATION}]"
          rsync -c --include="${PLUGIN_NAME}.jpi" --include="${PLUGIN_NAME}.hpi" --exclude="*" ${BACKUP_LOCATION}/* ${RESTORE_LOCATION}
        else
          echo "${PREFIX} Could not find plugin [${PLUGIN_NAME}] with correct hash locally in back up location [${BACKUP_LOCATION}]"
          ${RESTORE_SCRIPT_LOCATION}retrieve-plugin.sh "${PLUGIN_NAME}" "${PLUGIN_VERSION}" "${BACKUP_LOCATION}"
          # Check hash
          echo "${PLUGIN_HASH} ${PLUGIN_LOCATION}" > ${BACKUP_LOCATION}${PLUGIN_NAME}.md5
          md5sum --check ${BACKUP_LOCATION}${PLUGIN_NAME}.md5
          if [ $? == 0 ]; then
            # Restore
            echo "${PREFIX} Restoring downloaded plugin [${PLUGIN_NAME}] from back up location [${BACKUP_LOCATION}]"
            rm ${BACKUP_LOCATION}${PLUGIN_NAME}.md5
            rsync -c --include="${PLUGIN_NAME}.jpi" --include="${PLUGIN_NAME}.hpi" --exclude="*" ${BACKUP_LOCATION}/* ${RESTORE_LOCATION}
          else
            echo "${PREFIX} Hash does not match downloaded file, check that you have the correct version and hash on your back up file."
            exit 1
          fi
        fi
      else # No hash, retrieve online from Jenkins plugin centre
        echo "${PREFIX} No hash on file for plugin ${PLUGIN_NAME}"
        ${RESTORE_SCRIPT_LOCATION}retrieve-plugin.sh "${PLUGIN_NAME}" "${PLUGIN_VERSION}" "${BACKUP_LOCATION}"
        # Restore
        echo "${PREFIX} Restoring downloaded plugin [${PLUGIN_NAME}] from back up location [${BACKUP_LOCATION}]"
        rsync -c --include="${PLUGIN_NAME}.jpi" --include="${PLUGIN_NAME}.hpi" --exclude="*" ${BACKUP_LOCATION}/* ${RESTORE_LOCATION}
      fi
  else
    echo "${PREFIX} No file found in back up location [${BACKUP_LOCATION}] for plugin ${PLUGIN_NAME}"
    ${RESTORE_SCRIPT_LOCATION}retrieve-plugin.sh "${PLUGIN_NAME}" "${PLUGIN_VERSION}" "${BACKUP_LOCATION}"
    if [ ! -z ${PLUGIN_HASH} ];then
      # Check hash
      PLUGIN_LOCATION=$(find ${BACKUP_LOCATION} \( -name "${PLUGIN_NAME}.jpi" -o -name "${PLUGIN_NAME}.hpi" \))
      echo "${PLUGIN_HASH} ${PLUGIN_LOCATION}" > ${BACKUP_LOCATION}${PLUGIN_NAME}.md5
      if [ $? == 0 ]; then
        echo "${PREFIX} Hash matches for ${PLUGIN_LOCATION}"
        rm ${BACKUP_LOCATION}${PLUGIN_NAME}.md5
        # Does the version match? No idea! Would need to deploy and check
        echo "${PREFIX} Restoring plugin [${PLUGIN_NAME}] from back up location [${BACKUP_LOCATION}]"
        rsync -c --include="${PLUGIN_NAME}.jpi" --include="${PLUGIN_NAME}.hpi" --exclude="*" ${BACKUP_LOCATION}/* ${RESTORE_LOCATION}
      else
        echo "${PREFIX} Hash does not match downloaded file, check that you have the correct version and hash on your back up file."
        exit 1
      fi
    else
      echo "${PREFIX} No hash to check"
      echo "${PREFIX} Restoring downloaded plugin [${PLUGIN_NAME}] from back up location [${BACKUP_LOCATION}]"
      rsync -c --include="${PLUGIN_NAME}.jpi" --include="${PLUGIN_NAME}.hpi" --exclude="*" ${BACKUP_LOCATION}/* ${RESTORE_LOCATION}
    fi
  fi
done
# If there is no internet connectivity for wget/retrieve-plugin.sh then we need to handle the fact that a plugin without a hash is present in the back up
# How to handle downgrades where no hash has been provided and the version is older than the one we're replacing

