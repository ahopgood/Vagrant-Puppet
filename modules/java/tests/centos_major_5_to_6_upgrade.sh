#! /usr/bin/env bash

sudo puppet apply --execute "java{"java-5":\
version => '5', \
updateVersion => '22',\
}"

sudo puppet apply --execute "java{"java-6":\
version => '6', \
updateVersion => '45',\
}"