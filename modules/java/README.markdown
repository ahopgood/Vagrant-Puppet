# java #

This is the java module. It provides...
the Oracle Java Development Kit (JDK)

The module can be passed the following parameters as Strings:  
* Major version number, e.g. "6"
* Minor / update version number, e.g. "45"
* multiTenancy boolean, defaults to false to prevent unintentionally installing multiple JVMs
The module will default to jdk-6u45.

**64-bit support only**

Control over the JVM that is used as default is **not** provided as of yet.

Java Cryptography Extensions are **not** provided as of yet.  

## CentOS
Installation of a Java JDK from an RPM file.
RPM files with the appropriate minor-major numbers need to be located in the **files** folder for the passed parameters to allow for installation of the correct java version.

## Ubuntu
### Usage
 
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
	
#### <a href="Debian File naming conventions">Debian File naming conventions</a>
The *.deb* files with the appropriate minor-major numbers need to be located in the **files/Ubuntu/15.10** folder for the passed parameters to allow for installation of the correct java version.  
These deb files should be created using the **java-package** utility on a 64-bit version of Ubuntu 15.10 in order for the correct prerequisite libraries to be installed.  
The naming of these *.deb* files should follow the following convention in order for the correct version to be selected:  
**oracle-java&ltmajor_version$gt-jdk_&ltmajor_version$gtu&ltupdate_version$gt_amd64-Ubuntu_&ltubuntu_version$gt.deb**  
an example would be:  
`oracle-java8-jdk_8u31_amd64-Ubuntu_15.10.deb`

### Current Status / Support
Supports:
* Ubuntu 15.10 (Wily)
	* Major Java version 6,
	* Major Java version 7,
	* Major Java version 8.  

Installs Java Virtual Machine to `/usr/lib/jvm/jdk-<version>-oracle-x64/`

#### Tested:
* Install on fresh system
* Multi tenancy JVMs, i.e. 7 running alongside 8
	* Currently installs major versions alongside each other
	* Update versions are automatically upgraded
	* Currently the first installed jdk is the default in **alternatives**.
	* Multi tenanted JVMs can now be specified in a single puppet manifest using multiple defines sections instead of multiple runs to install the JVMs next to each other.
	* Note: Defaults
		* Currently the default JVM is the last installed version.
* Upgrades - in place between major versions (multiTenancy => false)
	* 6 to 7 - done
	* 7 to 8 - done
	* 6 to 8 - done
* Upgrades - in place between update versions with the same major version
	* 8u32 to 8u112 - done
	* 7u76 to 7u80 - done
	* 6u34 to 6u45 - done
* Downgrades - between major versions (multiTenancy => false)
	* 8 to 7 - done
	* 7 to 6 - done
	* 8 to 6 - done
* Downgrades - between update versions with the same major version
	* 8u112 to 8u32 - done
	* 7u80 to 7u76 - done
	* 6u45 to 6u34 - done
* reinstalling
	* a rerun of puppet will reinstall your JDK, this is because the JDK is uninstalled via **dpkg** to ensure that the previous update version is removed as the puppet dpkg  provider cannot remove with a specific version, it works only with a generic package name e.g. oracle-java6-jdk 		
Currently **not** tested:

### Multi Tenancy JVMs
Multi tenancy allows for multiple (major version **only**) JVMs to be installed at once, useful for certain testing environments and build servers to name two examples.  
`multiTenancy => false` is the default value, if present then other JVMs will be removed (as long as they are present in the versionsToRemove hash.  
You can only use the `java` or `java::ubuntu` defined resources **once** with multiTenancy disabled or else your manifest run will fail with a duplicate resource declaration for the **package** resource that removes the other JVM versions. In this way you get a hard failure on running multiTenancy disabled with multiple declarations.     
If the `multiTenancy => true` value is set then the `java` or `java::ubuntu` defined resources can be declared multiple times, once per major version number you wish to be deployed.  
This will result in your java installations all living side by side in the `/usr/lib/jvm` directory.  

### Adding compatibility for other Ubuntu versions
This module will attempt to locate the jdk deb files based on the `$::operatingsystem` and `$::operatingsystemmajrelease` puppet facts.  
In the case of Ubuntu 15.10 (Wily) these result in the values `Ubuntu` and `15.10` respectively.  
Both the folder structure under **files** and the deb naming should reflect this for the current version of Ubuntu and for support of future versions.   
The *.deb* installers will need to be created via **java-package** on your target version of Ubuntu in order to install correctly (this includes the correct bit version 32 vs 64-bit).  
Then try installing via `dpkg -i oracle-javax-jdk_xuxx_amd64/x86-Ubuntu_xx.xx.deb` on a blank OS install to see what dependencies and versions are required for that version of Ubuntu.  
The above mentioned dependencies can be encapsulated in an *if* clause based on the `$::operatingsystemmajrelease` value enabling the correct dependencies to be installed for your generated .deb file.  

### Adding new major versions of Java
Observe the packaging and [naming conventions](#Debian File naming conventions) mentioned previously.  
In the `ubuntu.pp` manifest you'll need to add a new mapping to the **versionsToRemove** hash for your new major version, specifying the removal of oracle-java6-jdk, oracle-java7-jdk and oracle-java8-jdk. 
Also add your new version to the hashes for every other version, e.g. oracle-java9-jdk.  

## ToDo
* Support for setting the Java Cryptography Extensions (JCE) via a define section.  
* Install defaults via alternatives
* Set defaults manually via alternatives

### CentOS
* Move CentOS code into separate manifest
* Update CentOS documentation with more information on usage and file naming strategy
* Multi tenancy

### Ubuntu
* Split out Ubuntu code into separate manifest
* Create the ability to set a **default** major version JVM via a parameter
* Use of definitions per major version using the **define** keyword, this will prevent puppet complaining about duplicate resources.