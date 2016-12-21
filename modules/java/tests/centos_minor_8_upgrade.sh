#! /usr/bin/env bash

sudo puppet apply --execute "java{"java-8":\
version => '8', \
updateVersion => '31',\
}"

sudo puppet apply --execute "java{"java-8":\
version => '8', \
updateVersion => '112',\
}"