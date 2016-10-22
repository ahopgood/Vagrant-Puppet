# java #

This is the java module. It provides...
Oracle Java Development Kit (JDK)

The module can be passed the following parameters as Strings:  
* Major version number
* Minor / update version number
The module will default to jdk-6u45.

Java Cryptography Extensions are **not** provided.  

## CentOS
Installation of a Java JDK from an RPM file.
RPM files with the appropriate minor-major numbers need to be located in the **files** folder for the passed parameters to allow for installation of the correct java version.

## Ubuntu
Supports:
* Ubuntu 15.10 (Wily)
	* Major Java version 6,
	* Major Java version 7,
	* Major Java version 8.  

Tested:
* Install on fresh system

Currently **not** tested:
* in place upgrades
* reinstalling
* downgrades
* multi tenancy JVMs, i.e. 7 running alongside 8

The *.deb* files with the appropriate minor-major numbers need to be located in the **files/Ubuntu/15.10** folder for the passed parameters to allow for installation of the correct java version.  
These deb files should be created using the **java-package** utility on a 64-bit version of Ubuntu 15.10 in order for the correct prerequisite libraries to be installed.  
The naming of these *.deb* files should follow the following convention in order for the correct version to be selected:  
**oracle-java<major_version>-jdk_<major_version>u<update_version>_amd64-Ubuntu_<ubuntu_version>.deb**  
an example would be:  
`oracle-java8-jdk_8u31_amd64-Ubuntu_15.10.deb`  

### Adding compatibility for other Ubuntu versions
This module will attempt to locate the jdk deb files based on the `$::operatingsystem` and `$::operatingsystemmajrelease` puppet facts.  
In the case of Ubuntu 15.10 (Wily) these result in the values `Ubuntu` and `15.10` respectively.  
Both the folder structure under **files** and the deb naming should reflect this for the current version of Ubuntu and for support of future versions.   
The *.deb* installers will need to be created via **java-package** on your target version of Ubuntu in order to install correctly (this includes the correct bit version 32 vs 64-bit).  
Then try installing via `dpkg -i oracle-javax-jdk_xuxx_amd64/x86-Ubuntu_xx.xx.deb` on a blank OS install to see what dependencies and versions are required for that version of Ubuntu.  
The above mentioned dependencies can be encapsulated in an *if* clause based on the `$::operatingsystemmajrelease` value enabling the correct dependencies to be installed for your generated .deb file.  