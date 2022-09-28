#!/bin bash

# find /var/lib/jenkins/plugins/ -type f -name *.hpi
# create a plugins.txt from $1
# Calc hashes for every file
# copy to a location $2
#

BACKUP_LOCATION=$1
PLUGIN_FILE="plugins.txt"
if [ ! -d "${BACKUP_LOCATION}" ]; then
    echo "The backup location [${BACKUP_LOCATION}] needs to be a directory"
    exit -1
fi
touch ${BACKUP_LOCATION}${PLUGIN_FILE}
echo ${BACKUP_LOCATION}${PLUGIN_FILE}
find /var/lib/jenkins/plugins/ -maxdepth 1 -type f \( -name '*.jpi' -o -name '*.hpi' \) | sort|
while read pluginName
do
    echo "Found plugin archive file [${pluginName}]"

    HASH=$(md5sum ${pluginName} | awk '{ print $1 }')
    echo "Calculated hash value [${HASH}]"

    PLUGIN_NAME=$(echo "${pluginName}" | awk -F '.' '{ print $1 }' | awk -F '/' '{ print $6 }')
    echo "Calculated plugin name [${PLUGIN_NAME}]"
    PLUGIN_VERSION=$( unzip -c ${pluginName} META-INF/MANIFEST.MF | grep 'Plugin-Version' |  tr -d '\n' | tr -d '\r' | awk '{ print $2 }' )
#    PLUGIN_VERSION=$( grep 'Plugin-Version' /var/lib/jenkins/plugins/$PLUGIN_NAME/META-INF/MANIFEST.MF | tr -d '\n' | tr -d '\r' | awk '{ print $2 }' )
    echo "Found plugin version [${PLUGIN_VERSION}]"
#    echo "${PLUGIN_NAME}:${PLUGIN_VERSION}:${HASH}"

    # Might need to trim leading whitespace
    # Check if we have an entry already for this plugin
    grep "${PLUGIN_NAME}:${PLUGIN_VERSION}:${HASH}" ${BACKUP_LOCATION}${PLUGIN_FILE}
#    echo "${PLUGIN_NAME}:${PLUGIN_VERSION}:${HASH}"
    if [ $? == 0 ]; then
        echo "Identical entry already found in ${BACKUP_LOCATION}${PLUGIN_FILE} for ${PLUGIN_NAME}"
    else
        # Use sed to replace the value that has changed
        EXISTING=$(grep -x "${PLUGIN_NAME}:.*:.*" ${BACKUP_LOCATION}${PLUGIN_FILE})
        if [ $? == 0 ]; then
            EXISTING_VERSION=$(echo "${EXISTING}" | awk -F ':' '{ print $2 }')
            echo "Have found an existing entry for ${PLUGIN_NAME} at version ${EXISTING_VERSION}"

            # compare versions
            #dpkg --compare-versions ${PLUGIN_VERSION} "gt" ${EXISTING_VERSION} # won't work with versions with git hashes appended which many jenkins official plugins are using now
#            echo ${PLUGIN_VERSION} ${EXISTING_VERSION} | sort -V | tail -n1 == ${PLUGIN_VERSION}

#            if [ $? == 0 ]; then
            if [ $(printf "%s\n%s" "${PLUGIN_VERSION}" "${EXISTING_VERSION}" | sort -V | tail -n1) == "${PLUGIN_VERSION}" ]; then
              echo "Updating from [${EXISTING}] to [${PLUGIN_NAME}:${PLUGIN_VERSION}:${HASH}]"
              sed -i 's/'${PLUGIN_NAME}':.*:.*/'$PLUGIN_NAME':'$PLUGIN_VERSION':'$HASH'/' ${BACKUP_LOCATION}${PLUGIN_FILE}
              #sed -i -e 's/junit:.*:.*/junit:1.21:abe2691c6e487431d9253f07e905c389/' plugins.txt
              echo "Removing old ${PLUGIN_NAME}:${EXISTING_VERSION} from ${BACKUP_LOCATION}${PLUGIN_NAME}"
#              rsync -d --delete-before "${BACKUP_LOCATION}${PLUGIN_NAME}".*
              rm "${BACKUP_LOCATION}${PLUGIN_NAME}".*

              echo "Copying new ${pluginName} [${PLUGIN_VERSION}] to ${BACKUP_LOCATION}${PLUGIN_NAME}"
              rsync -c ${pluginName} ${BACKUP_LOCATION}
            else
              echo "${PLUGIN_VERSION} is not newer than ${EXISTING_VERSION}"
            fi
        else # entry is completely new
            echo "${PLUGIN_NAME}:${PLUGIN_VERSION}:${HASH}"
            echo "${PLUGIN_NAME}:${PLUGIN_VERSION}:${HASH}" >> ${BACKUP_LOCATION}${PLUGIN_FILE}
            echo "Copying ${pluginName} to ${BACKUP_LOCATION}${PLUGIN_NAME}"
            rsync -c ${pluginName} ${BACKUP_LOCATION}
        fi
    fi
done
