# Java 

This is the java module. It provides...
the Oracle Java Development Kit (JDK) (6,7,8u212) and the AdoptOpenJdk distribution (8u232, 11+)

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
* Ubuntu 15.10 (Wily)
	* **Oracle** Major Java version 6,
	* **Oracle** Major Java version 7,
	* **Oracle** Major Java version 8 up to 8u112.  
* CentOS 6
	* **Oracle** Major Java version 5,
	* **Oracle** Major Java version 6,
	* **Oracle** Major Java version 7,
	* **Oracle** Major Java version 8 up to 8u112.
* Ubuntu 16.04 (Xenial)
    * **Oracle** Major Java version 6,
    * **Oracle** Major Java version 7,
    * **Oracle** Major Java version 8 up to 8u212 (Now End of Life - EOL)
    * **AdoptOpenJDK** Major Java version 8
        * 8u222
        * 8u232
        * 8u242
    * **AdoptOpenJDK** Major Java version 11
        * 11u3
        * 11u4
        * 11u5
        * 11u6
    
### Known Issues  

**64-bit support only**  
[CentOS Known Issues](#CentOS_known_issues)  
[Ubuntu Known Issues](#Ubuntu_known_issues)  

`isDefault` cannot currently be set for more than **one** JDK in a multi-tenancy environment.  

## Usage
### Single JVM usage 
Can be declared via the *java* definition:
	
	java{"java-7":
		version => '7',
		update_version => '76'
	}	

### Multi Tenancy JVM Usage
Set Java 7 to be the default manually JVM by overriding the alternatives priority ordering that would *usually* favour Java 8: 

	java{"java-8":
		version => '8',
		update_version => '31',
		multiTenancy => true,
		isDefault => true,
	}
	java{"java-7":
		version => '7',
		update_version => '76',
		multiTenancy => true,
	}

Or explicitly call the *java::default::set* definition yourself

	java{"java-8":
		version => '8',
		update_version => '31',
		multiTenancy => true,
	}
	java{"java-7":
		version => '7',
		update_version => '76',
		multiTenancy => true,
	}
	->
	java::default::set { "set-java-7-as-default":
		version => "7",		
	}
	 
#### Notes on Multi Tenancy JVMs
Multi tenancy allows for multiple (major version **only**) JVMs to be installed at once, useful for certain testing environments and build servers to name two examples.  
`multiTenancy => false` is the default value, if present then other JVMs will be removed (as long as they are present in the versionsToRemove hash.  
You can only use the `java`, `java::ubuntu`, `java::centos` defined resources **once** with multiTenancy disabled or else your manifest run will fail with a duplicate resource declaration for the **package** resource that removes the other JVM versions. In this way you get a hard failure on running multiTenancy disabled with multiple declarations.     
If the `multiTenancy => true` value is set then the `java` or `java::ubuntu` defined resources can be declared multiple times, once per major version number you wish to be deployed.  
This will result in your java installations all living side by side in the `/usr/lib/jvm` directory.  

## Testing
There are test scripts that can be used to test the most efficient upgrade/downgrade paths for different tenancy types:
* `/tests/scripts/ubuntu/multi-tenancy.sh`
* `/tests/scripts/ubuntu/multi-tenancy-minor-upgrade.sh`
* `/tests/scripts/ubuntu/single-tenancy.sh`
* `/tests/scripts/ubuntu/single-tenancy-minor-upgrade.sh`

The `/test/scripts/java-test.sh` script is a utility script that allows you to test if a desire major-minor version of Java is installed and how many other multi-tenancy installations are present.  
For facilitate testing the `/tests/` folder contains puppet manifests for calling different versions of Java with varying default or multi-tenancy options.
 
Testing performed:
* Install single JDK on fresh system
* Multi tenancy JVMs, i.e. 7 running alongside 8
	* Currently installs major versions alongside each other
	* Update versions are automatically upgraded
	* Multi tenanted JVMs can now be specified in a single puppet manifest using multiple defines sections instead of multiple runs to install the JVMs next to each other.
* Upgrades - in place between major versions (multiTenancy => false)
	* 6 to 7
	* 7 to 8
	* 6 to 8
* Upgrades - in place between update versions with the same major version
	* 8u32 to 8u112
	* 7u76 to 7u80
	* 6u34 to 6u45
* Downgrades - between major versions (multiTenancy => false)
	* 8 to 7
	* 7 to 6
	* 8 to 6
* Downgrades - between update versions with the same major version
	* 8u112 to 8u32
	* 7u80 to 7u76
	* 6u45 to 6u34
* reinstalling - Ubuntu specific currently
	* a rerun of puppet will reinstall your JDK, this is because the JDK is uninstalled via **dpkg** to ensure that the previous update version is removed as the puppet dpkg  provider cannot remove with a specific version, it works only with a generic package name e.g. oracle-java6-jdk 		
* Set defaults via alternatives
	* Java 6 - done
	* Java 7 - done
	* Java 8 - done

## Java Cryptography Extensions (JCE)
This module only supports:
* Oracle Java 6
* Oracle Java 7
* Oracle Java 8

**Any** version of AdoptOpenJDK will use unlimited strength Java Cryptography Extensions by default.   

### JCE Naming Conventions

In order to locate the archive files containing the JCE extensions they need to be named appropriately following this scheme:
`jce_policy-*jdk_major_version*.zip` where jdk_major_version reflects the major version of the SDK you want to install the extensions for.
For example:
* Java 6 -> `jce_policy-6.zip`
* Java 7 -> `jce_policy-7.zip`
* Java 8 -> `jce_policy-8.zip`
Unlike the JDK installers these are not platform dependent so are located in the root `/files` folder for the module.


#### To Do

* Minor versions of the same major version need to work on multi-tenancy environments
* Need to be able to use multiple major versions on the same environment

<a name="centos"></a>
## CentOS
Installs the Java Virtual Machine to `/usr/java/jdk1.<version>.0_<update_version>`

Installation of a Java JDK from an RPM file.
RPM files with the appropriate minor-major numbers need to be located in the **files** folder for the passed parameters to allow for installation of the correct java version.

<a href="CentOS_known_issues"></a>
### Known issues
* Major version downgrades - alternatives are not removed so the previous version will still be pointed to. 
* Multi-tenancy JVMs - removing a JVM from the manifest will leave it still installed on the file system.

<a name="CentOS_File_naming_conventions"></a>
### CentOS File naming conventions
The *.rpm* files with the appropriate minor-major numbers need to be located in the **files/CentOS/6** folder for the passed parameters to allow for installation of the correct java version.  
The *current* file naming structure by Oracle has no OS dependent parts and simply takes the following forms based on major versions:  
* **Java 5** - jdk-1_<version>_0_<update_version>-linux-amd64.rpm
* **Java 6** - jdk-<version>u<update_version>-linux-amd64.rpm
* **Java 7 & 8** - jdk-<version>u<update_version>-linux-x64.rpm
Ensuring this pattern is followed will allow the module to locate files correctly, it was decided not to rename all the JDKs into a common naming structure since this places the onus on the person running the module to rename files every time there is an update.  

This decision may be revisited in future in order to simplify the module if Oracle continue to change their naming scheme.  

These rpm files can be found on the [Oracle download page](http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html) and the [archive page](http://www.oracle.com/technetwork/java/javase/archive-139210.html) for older versions.

### Adding compatibility for other CentOS versions
This module will attempt to locate the jdk rpm files based on the `$::operatingsystem` and `$::operatingsystemmajrelease` puppet facts.  
In the case of CentOS 6 these result in the values `CentOS` and `6` respectively, the folder structure under **files** should reflect this by looking in */files/CentOS/6/* for installers, this pattern should be followed for support of future versions of CentOS.   

### Adding new major versions of Java
Observe the packaging and [naming conventions](#CentOS_File_naming_conventions) mentioned previously.  
Be wary of renamed packages or new formats by checking `rpm -qa jdk*` after doing a manual rpm install.  

<a name="ubuntu"></a>
## Ubuntu
* Installs the **Oracle** Java Virtual Machine to `/usr/lib/jvm/jdk-<version>-oracle-x64/`
* Installs the **AdoptOpenJdk** Java Virtual Machine to `/usr/lib/jvm/adoptopenjdk-<version>-hotspot-amd64/`
* Installation of a Java JDK from a .deb file.

<a name="Ubuntu_known_issues"></a>
### Ubuntu known issues
* Multi-tenancy JVMs - currently removing of a java declaration won't remove it from the system, this is a scope issue, each instance doesn't know what other major versions are installed, they can clean up their minor versions without issue.  
* **Oracle** Java stops at version 8u212 
* **AdoptOpenJdk** Java picks up from version 8u232
 
#### AdoptOpenJdk
Due to Oracle Java 8's end of life it is no longer receiving updates unless a professional subscription is paid.  
In order to continue receiving updates the switch to the [AdoptOpenJdk](https://adoptopenjdk.net/) distribution of Java has been made.  

You can use the same `java` class as an entrypoint, the major and update versions of 8u232 will be used to determine when to delegate to the `openjdk` class:
```
java {"my-openjdk-8":
	version => '8',
	update_version => '232'
}	
```
Things to note about the `openjdk` class:
* It installs from a `.deb` under the file namespace `/files/Ubuntu/16.04/` (currently only Xenial is supported)
* `update-java-alternatives` from the `java-common` package is now used to manage the alternatives subsystem for AdoptOpenJdk Java. 
* The `openjdk` class will remove Oracle Java if **not** using multi-tenancy
* The `openjdk` install is unable to co-exist in a multi-tenancy environment with Oracle Java 8 due to shared named resources in the Java module and the major version number being central to resource uniqueness.
* The `openjdk` class can multi-tenant with other versions of Oracle Java except for 8.

Migration for **multi-tenant** Oracle Java 8 installs to replace with AdoptOpenJdk 8 is best achieved via the following steps:
1. Comment out all Java resources except for Java 8
2. Update the Java 8 resource to `update_version => "232"` with `multiTenancy => false` and apply puppet to remove **all** Oracle Java installations
3. Re-instate all commented out Oracle Java resources, set Java 8 to `multiTenancy => true`
3. Apply puppet again to reinstall the remaining Oracle Java resource

<a name="Debian_file_naming_conventions"></a>
### Debian File naming conventions
The *.deb* files with the appropriate minor-major numbers need to be located in the **files/Ubuntu/15.10** folder for the passed parameters to allow for installation of the correct java version.  
These deb files should be created using the [java-package](https://wiki.debian.org/JavaPackage) utility on a 64-bit version of Ubuntu 15.10 in order for the correct prerequisite libraries to be installed.  
```
sudo apt-get install java-package
make-jpkg jdk-7u80-linux-x64.tar.gz
```

The naming of these *.deb* files should follow the following convention in order for the correct version to be selected:  
**oracle-java<major_version>-jdk_<major_version>u<update_version>_amd64-Ubuntu_<ubuntu_version>.deb**  
an example would be:  
`oracle-java8-jdk_8u31_amd64-Ubuntu_15.10.deb`
The binary files can be found on the [Oracle download page](http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html) and the [archive page](http://www.oracle.com/technetwork/java/javase/archive-139210.html) for older versions

### Adding compatibility for other Ubuntu versions
This module will attempt to locate the jdk deb files based on the `$::operatingsystem` and `$::operatingsystemmajrelease` puppet facts.  
In the case of Ubuntu 15.10 (Wily) these result in the values `Ubuntu` and `15.10` respectively.  
Both the folder structure under **files** and the deb naming should reflect this for the current version of Ubuntu and for support of future versions.   
The *.deb* installers will need to be created via **java-package** on your target version of Ubuntu in order to install correctly (this includes the correct bit version 32 vs 64-bit).  
Then try installing via `dpkg -i oracle-javax-jdk_xuxx_amd64/x86-Ubuntu_xx.xx.deb` on a blank OS install to see what dependencies and versions are required for that version of Ubuntu.  
The above mentioned dependencies can be encapsulated in an *if* clause based on the `$::operatingsystemmajrelease` value enabling the correct dependencies to be installed for your generated .deb file.  

### Adding new major versions of Java
Observe the packaging and [naming conventions](#Debian_file_naming_conventions) mentioned previously.  
In the `ubuntu.pp` manifest you'll need to add a new mapping to the **versionsToRemove** hash for your new major version, specifying the removal of oracle-java6-jdk, oracle-java7-jdk and oracle-java8-jdk. 
Also add your new version to the hashes for every other version, e.g. oracle-java9-jdk.  


## ToDo
* Support for setting the Java Cryptography Extensions (JCE) via a define section.  
* Install defaults via alternatives - done
	* Get this working where the alternative is installed but we want a higher priority to override.
* Some sort of test suite to prevent unintentional regression
	* Could define test manifests for conditions
	* Could use a snapshot of the VMs to ensure quick run time
	* Needs to be platform agnostic as ssh will not work on windows, or will it?
* Add installation support for new Java versions modelled on [install-java.sh](https://github.com/chrishantha/install-java)
### CentOS
* Update CentOS documentation with more information on usage and file naming strategy - done
* Multi tenancy - done
* Set defaults manually via alternatives - done

### Ubuntu
* Create the ability to set a **default** major version JVM via a parameter - done
