#! /usr/bin/env bash

sudo puppet apply --execute "java{"java-6":\
version => '6', \
updateVersion => '45',\
}"

sudo puppet apply --execute "java{"java-8":\
version => '8', \
updateVersion => '31',\
}"