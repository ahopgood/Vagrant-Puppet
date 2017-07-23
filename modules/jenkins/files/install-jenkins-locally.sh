#! /usr/bin/env bash

#if [ ! -e /etc/apt/sources.list.d/java-8-debian.list ]; then
#	sudo touch /etc/apt/sources.list.d/java-8-debian.list
#fi
#	chmod 447 /etc/apt/sources.list.d/java-8-debian.list
#sudo echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" > /etc/apt/sources.list.d/java-8-debian.list
#sudo echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/java-8-debian.list

#echo debconf shared/accepted-oracle-license-v1-1 select true | \
#  sudo debconf-set-selections
#echo debconf shared/accepted-oracle-license-v1-1 seen true | \
#  sudo debconf-set-selections

#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
#sudo apt-get update
#sudo apt-get install -y oracle-java8-installer

#this version only works on wheezy
#Requires libasound2 >= 1.0.16
#Requires libgtk2.0-0 >= 2.24.0

#sudo dpkg -i /vagrant/debs/oracle-java8-jdk_8u112_amd64-Ubuntu_15_10.deb

#Requires the daemon package
JENKINS_PKG=$(ls -1 /vagrant/debs | tail -n 1 )
sudo dpkg -i $JENKINS_PKG
