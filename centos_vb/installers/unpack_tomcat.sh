#!/bin/bash
tomcat_short_ver=tomcat7
tomcat_full_ver=apache-tomcat-7.0.54
tomcat_archive=/etc/puppet/installers/${tomcat_full_ver}.tar.gz

echo printing tomcat archive
echo ${tomcat_archive}
echo after printing archive

#Uncompress
/bin/gzip -d /etc/puppet/installers/${tomcat_full_ver}.tar.gz

#Unpack archive
cd  /etc/puppet/installers/
/bin/tar xf /etc/puppet/installers/${tomcat_full_ver}.tar

#Change unpacked directory modification permissions
/bin/chmod 777 /etc/puppet/installers/${tomcat_full_ver}

#Rename the apache-tomcat-7.0.54 directory to tomcat7
/bin/mv /etc/puppet/installers/${tomcat_full_ver} /etc/puppet/installers/${tomcat_short_ver}

/bin/cp -R /etc/puppet/installers/${tomcat_short_ver} /var/hosting/
#update the permissions for the entire tomcat7 directory structure otherwise it will be read and execute by host only.

#/bin/rm -R /etc/puppet/installers/${tomcat__full}
/bin/rm -R /etc/puppet/installers/${tomcat__full}.tar
/bin/rm -R /etc/puppet/installers/${tomcat_short_ver}