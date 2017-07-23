#! /usr/bin/env bash

sudo puppet apply --execute "java{"java-8":\
version => '8', \
update_version => '31',\
}"

sudo puppet apply --execute "java{"java-8":\
version => '8', \
update_version => '112',\
}"