#! /usr/bin/env bash

sudo puppet apply --execute "java{"java-6":\
version => '6', \
update_version => '45',\
}"

sudo puppet apply --execute "java{"java-7":\
version => '7', \
update_version => '76',\
}"