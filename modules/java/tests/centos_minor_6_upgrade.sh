#! /usr/bin/env bash

sudo puppet apply --execute "java{"java-6":\
version => '6', \
update_version => '34',\
}"

sudo puppet apply --execute "java{"java-6":\
version => '6', \
update_version => '45',\
}"