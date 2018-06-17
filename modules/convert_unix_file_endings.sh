#!/usr/bin/env bash

# This script is for copying the .rpm and .deb installer files from the puppet modules to a specified directory.
# Makes use of the 'find' command to scour the modules/{module_name}/files/{os}/{version}/ directory structure

echo "Converting bash scripts to unix line endings"
dos2unix **/files/*.sh
dos2unix **/templates/*.sh.erb
