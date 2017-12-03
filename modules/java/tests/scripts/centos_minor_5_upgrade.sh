#! /usr/bin/env bash

sudo puppet apply --execute "java{"java-5":\
version => '5', \
update_version => '22',\
}"

sudo puppet apply --execute "java{"java-5":\
version => '5', \
update_version => '',\
}"