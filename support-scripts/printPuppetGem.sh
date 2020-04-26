#! /usr/bin/env bash

GEM_NAME=$1
if [ -z $GEM_NAME ]; then
  printf "%s\n" "Please provide a gem name"
  exit -1
fi
GEM_FILE_NAME=$(ls -1 | grep ${GEM_NAME})
printf "%s[%s]\n" "Package file name:" ${GEM_FILE_NAME}

if [ -z $GEM_FILE_NAME ]; then
  printf "%s\n" "Gem has not been downloaded yet."
  gem fetch ${GEM_NAME}

  GEM_FILE_NAME=$(ls -1 | grep ${GEM_NAME})
  printf "%s%s\n" "Gem file name: " ${GEM_FILE_NAME}
fi

DIR=$(dirname $0)
echo "Directory of script: ${DIR}"

SANITISED_GEM_NAME=$(echo "${GEM_NAME}" | sed 's/-/_/g' | sed 's/\./_/g')
sed 's/GEM_FILE_NAME/'${GEM_FILE_NAME}'/' ${DIR}/gem.template \
| sed 's/GEM_NAME/'${GEM_NAME}'/' \
| sed 's/GEM_FILE_ID/'${SANITISED_GEM_NAME}'/'

printf "%s\n"
mv ${GEM_FILE_NAME} /vagrant/files/$(lsb_release -s -i)/$(lsb_release -s -r)
