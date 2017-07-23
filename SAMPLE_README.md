# java #

This is the java module. It provides...
the Oracle Java Development Kit (JDK)

The module can be passed the following parameters as Strings:  
* Major version number, e.g. "6"
* Minor / update version number, e.g. "45"
* multiTenancy boolean, defaults to false to prevent unintentionally installing multiple JVMs
* isDefault boolean, uses alternatives to manually override the priority based ordering of multi-tenancy JVMs
The module will default to jdk-6u45.

JVM defaults are based on major versions, e.g. JDK 8 trumps JDK 7 etc unless manually overridden using the isDefault flag.

Java Cryptography Extensions are **not** provided as of yet.  
## Current Status / Support
Supports:
* CentOS 6

### Known Issues  
**64-bit support only**  
[CentOS Known Issues](#CentOS_known_issues)  
[Ubuntu Known Issues](#Ubuntu_known_issues)  

## Usage 
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
or directly via the *java::centos* definition:
	
	java::centos{"java-6":
	  version => "6",
	  updateVersion => "45"
	}	   

## Testing performed:
* Install on a fresh system
	* CentOS6
	* CentOS7
	* Ubuntu 15.10
	
## CentOS
Installs the Java Virtual Machine to `/usr/java/jdk1.<version>.0_<updateVersion>`

Installation of a Java JDK from an RPM file.
RPM files with the appropriate minor-major numbers need to be located in the **files** folder for the passed parameters to allow for installation of the correct java version.
### <a name="CentOS_known_issues">Known issues</a>
* 

### <a name="CentOS_File_naming_conventions">CentOS File naming conventions</a>
The *.rpm* files with the appropriate minor-major numbers need to be located in the **files/CentOS/6** folder for the passed parameters to allow for installation of the correct apache httpd version.  
Ensuring this pattern is followed will allow the module to locate files correctly, it was decided not to rename all the rpms into a common naming structure since this places the onus on the person running the module to rename files every time there is an update.  

This decision may be revisited in future in order to simplify the module if the Apache foundation continue to change their naming scheme.  
### Adding compatibility for other CentOS versions

### Adding new major versions of Apache


## Ubuntu
### <a name="Ubuntu_known_issues">Ubuntu known issues</a>

### <a namme="Debian_file_naming_conventions">Debian File naming conventions</a>
The *.deb* files with the appropriate minor-major numbers need to be located in the **files/Ubuntu/15.10** folder for the passed parameters to allow for installation of the correct apache2 version.  
<!--
The naming of these *.deb* files should follow the following convention in order for the correct version to be selected:  
**apache2_&ltmajor_version$gt%2E&ltminor_version$gt%2E&ltpatch_version$gt-Ubuntu_&ltubuntu_version$gt_amd64.deb**  
an example would be:  
`apache2_2.4.12-Ubuntu_15.10_amd64.deb`
-->
### Adding compatibility for other Ubuntu versions
### Adding new major versions of Apache

## ToDo
### CentOS
### Ubuntu
