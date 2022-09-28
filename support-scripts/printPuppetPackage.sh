#! /usr/bin/env bash

PACKAGE_NAME=$1
VERSION=$2
if [ -z $PACKAGE_NAME ]; then
  printf "%s\n" "Please provide a package name"
  exit 3
fi
PACKAGE_FILE_NAME=$(ls -1 | grep ${PACKAGE_NAME})
printf "%s[%s]\n" "Package file name:" ${PACKAGE_FILE_NAME}

if [ -z $PACKAGE_FILE_NAME ]; then
  printf "%s\n" "Package has not been downloaded yet."
  apt-get update
  if [ -z $VERSION ]; then
    apt-get download ${PACKAGE_NAME}
  else
    printf "%s\n" "A version [${VERSION}] has been provided."
    apt-get download ${PACKAGE_NAME}=${VERSION}
  fi

  PACKAGE_FILE_NAME=$(ls -1 | grep ${PACKAGE_NAME})
  printf "%s%s\n" "Package file name: " ${PACKAGE_FILE_NAME}
fi

DIR=$(dirname $0)
echo "Directory of script: ${DIR}"

SANITISED_PACKAGE_NAME=$(echo "${PACKAGE_NAME}" | sed 's/-/_/g' | sed 's/\./_/g')
sed 's/PACKAGE_FILE_NAME/'${PACKAGE_FILE_NAME}'/' ${DIR}/package.template \
| sed 's/PACKAGE_NAME/'${PACKAGE_NAME}'/' \
| sed 's/PACKAGE_FILE_ID/'${SANITISED_PACKAGE_NAME}'/'

printf "%s\n"
mv ${PACKAGE_FILE_NAME} /vagrant/files/$(lsb_release -s -i)/$(lsb_release -s -r)
