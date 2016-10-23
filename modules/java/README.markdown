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

Can be declared via the *java* definition:
	
	java{"java-7":
		version => '7',
		updateVersion => '76'
	}
	
or directly via the *java::ubuntu* definition:

	java::ubuntu{"java-6":
	  version => "6",
	  updateVersion => "45"
	} 

Supports:
* Ubuntu 15.10 (Wily)
	* Major Java version 6,
	* Major Java version 7,
	* Major Java version 8.  

Installs Java Virtual Machine to `/usr/lib/jvm`

Tested:
* Install on fresh system
* Multi tenancy JVMs, i.e. 7 running alongside 8
	* Currently installs major versions alongside each other
	* Update versions are automatically upgraded
	* Currently the first installed jdk is the default in **alternatives**.
	* Multi tenanted JVMs can now be specified in a single puppet manifest using multiple defines sections instead of multiple runs to install the JVMs next to each other.
* in place upgrades between update versions with the same major version
	* 8u32 to 8u112 - done
	* 7u76 to 7u80 - done
	* 6u34 to 6u45 - done
* downgrades between update versions with the same major version
	* 8u112 to 8u32 - done
	* 7u80 to 7u76 - done
	* 6u45 to 6u34 - done
		
Currently **not** tested:
* in place upgrades between major versions
	* 6 to 7
	* 7 to 8
	* 6 to 8
* downgrades between major versions
	* 8 to 7 - failed
	* 7 to 6 -
	* 8 to 6 -
* reinstalling
	* a rerun of puppet will reinstall your JDK, this is because the JDK is uninstalled via **dpkg** to ensure that the previous update version is removed as the puppet dpkg  provider cannot remove with a specific version, it works only with a generic package name e.g. oracle-java6-jdk 
* Defaults
	* Currently the default JVM is the last installed version.

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

## ToDo
### CentOS
* Move CentOS code into separate manifest
### Ubuntu
* Split out Ubuntu code into separate manifest
* Create the ability to set a default major version via a parameter
* Create the ability to have multi tenanted JVMs via a parameter, without the tenancy set to true we will remove any other major versions of the oracle JVM (just list we do to enable downgrades of updates). 
* Use of definitions per major version using the **define** keyword, this will prevent puppet complaining about duplicate resources.