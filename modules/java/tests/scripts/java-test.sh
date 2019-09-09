#! /usr/bin/env bash

set -e
RETURN_CODE=0
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

function help() {
  printf "This test script will verify Java installations have occurred in a manner that is expected of them.\n"
  printf "\t -v <major-java-version> the major version to check\n"
  printf "\t -i <update-java-version> minor version to check\n"
  printf "\t -m <install-count> (optional) flag to allow multi-tenancy installations of major Java versions, defaults to false, if true requires the expected number of installations\n"
}

function fail() {
  printf "%-60s %6s\n" "${1}" "[${RED}Fail${NORMAL}]"
}

function success() {
  printf "%-60s %4s\n" "${1}" "[${GREEN}OK${NORMAL}]"
}

function check_java_version() {
  VERSION=$1
  MINOR_VERSION=$2
  #Validation check
  FOUND_VERSION=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')

  if [ "$FOUND_VERSION" == "1.$VERSION.0_$MINOR_VERSION" ]; then
    success "Installed ${FOUND_VERSION} correctly"
  else
    fail "Found ${FOUND_VERSION} expected version 1.${VERSION}.0_${MINOR_VERSION}"
    RETURN_CODE=-1
  fi
}

function check_single_tenancy() {
  check_tenancy $1 $2 "1"
}

function check_multiple_tenancy() {
  check_tenancy $1 $2 $3
}

function check_tenancy() {
  VERSION=$1
  MINOR_VERSION=$2
  VERSIONS_FOUND=$(expr $(ls -1 /usr/lib/jvm | wc -l) - 1)
  VERSIONS_EXPECTED=$3
  if [ "${VERSIONS_FOUND}" != "${VERSIONS_EXPECTED}" ]; then
    fail "Found [$VERSIONS_FOUND] major JDKs, was expecting [$VERSIONS_EXPECTED] JDKs"
    RETURN_CODE=-1
  else
    success "Found the expected number of JDK(s): [${VERSIONS_EXPECTED}]"
  fi

}

MULT_TENANCY=false
while getopts "v:u:m:h" opt; do
  case $opt in
    v)  MAJOR_VERSION=$OPTARG
    ;;
    u)  UPDATE_VERSION=$OPTARG
    ;;
    m)  MULTI_TENANCY=true
        INSTALL_COUNT=$OPTARG
    ;;
    h|\?)
      help
      exit -1
    ;;
  esac
done

if [ -z $MAJOR_VERSION ];then
   printf "%s\n" "A major Java version is required."
   help
   exit -1
fi

if [ -z $UPDATE_VERSION ];then
  printf "%s\n" "An update Java version is required."
  help
  exit -1
fi

check_java_version $MAJOR_VERSION $UPDATE_VERSION
if [ $MULTI_TENANCY ]; then
  # Checking for multi-tenancy
  if [ -z $INSTALL_COUNT ];then
    printf "%s\n" "An expected install count is required."
    help
    exit -1
  else
    check_multiple_tenancy $MAJOR_VERSION $UPDATE_VERSION $INSTALL_COUNT
  fi
else
  check_single_tenancy $MAJOR_VERSION $UPDATE_VERSION
fi
exit $RETURN_CODE
