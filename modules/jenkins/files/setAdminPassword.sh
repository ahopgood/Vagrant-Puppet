#!/usr/bin/env bash
DEFINE_VAR="defvar ADMIN_DIR /files/var/lib/jenkins/users/users.xml/hudson.model.UserIdMapper/idToDirectoryNameMap/entry[.]/string[.]/#text[. =~ regexp(\"admin_.*\")]"
GET_ADMIN_DIR="get \$ADMIN_DIR"

ADMIN_DIR=$(printf "%s\n%s" "${DEFINE_VAR}" "${GET_ADMIN_DIR}" | augtool -At "Xml.lns incl /var/lib/jenkins/users/users.xml" | awk '{ print $3 }')

echo "Found admin directory: ${ADMIN_DIR}"

#HASH_VALUE="#jbcrypt:\$2a\$10\$2dr50M9GvFH49WjsOASfCe3dOVctegmK8SRtAJEIrzSPbjSTGhfkacccc"
HASH_VALUE="${1}"
SET_HASH="set /files/var/lib/jenkins/users/${ADMIN_DIR}/config.xml/user/properties/hudson.security.HudsonPrivateSecurityRealm_-Details/passwordHash/#text #jbcrypt:"
SAVE="save"
printf "%s%s\n%s" "${SET_HASH}" "${HASH_VALUE}" "${SAVE}" | augtool -At "Xml.lns incl /var/lib/jenkins/users/${ADMIN_DIR}/config.xml"
echo $?
