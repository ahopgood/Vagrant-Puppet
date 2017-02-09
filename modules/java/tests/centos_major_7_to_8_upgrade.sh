#! /usr/bin/env bash

sudo puppet apply --execute "java{"java-7":\
version => '7', \
update_version => '76',\
}"

sudo puppet apply --execute "java{"java-8":\
version => '8', \
update_version => '31',\
}"