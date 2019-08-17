#! /usr/bin/env bash

sudo puppet apply --execute "java{"java-5":\
version => '5', \
update_version => '22',\
}"

sudo puppet apply --execute "java{"java-6":\
version => '6', \
update_version => '45',\
}"

java -version 2>&1 |  grep "java version \"1.6.*\""
if [ $? == 0 ]
then
    echo "PASS"
else
    exit -1
fi
