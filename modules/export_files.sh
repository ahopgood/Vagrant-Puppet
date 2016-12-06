#!/usr/bin/env bash

find . \( -name '*.deb' -o -name '*.rpm' \) -exec cp --parents {\} $1 \;

# Java 8 creates a new package for every update version, they get installed side by side
# remove old versions of Java 8
# sudo rpm -e $(ls -1 /usr/java/ | grep jdk)
# sudo rpm -e $(ls -1 /usr/java/ | grep "jdk1.8.*")
# sudo rpm -e $(rpm -q jdk1.8*)

# Remove old versions of Java 7
# sudo rpm -e $(rpm -q jdk-1.7*)