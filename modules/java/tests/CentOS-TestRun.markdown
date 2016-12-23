## Centos Test Run
sudo puppet apply /vagrant/manifests/test_centos.pp
rpm -e $(rpm -qa | grep jdk-1.6.* | grep -v 'jdk-1.6.0_34')

rpm -e $(rpm -qa | grep jdk* | grep -v 'jdk1.8.0_31-1.8.0_31-fcs.x86_64')
* Install single JDK on fresh system
	* Java 5 - done
	* Java 6 - done
	* Java 7 - done
	* Java 8 - done
* Multi tenancy JVMs, i.e. 7 running alongside 8
	* Currently installs major versions alongside each other
	* Update versions are automatically upgraded
	* Multi tenanted JVMs can now be specified in a single puppet manifest using multiple defines sections instead of multiple runs to install the JVMs next to each other.
	* Old major versions are still installed, not sure how to fix this without a complete re-organisation.
* Upgrades - in place between update versions with the same major version
	* 8u32 to 8u112 - done 
	* 7u76 to 7u80 - done
	* 6u34 to 6u45 - done
	* 5u22 to 5u20 - done
* Downgrades - between update versions with the same major version, 
rpm with the puppet package manager doesn't like downgrades
	* 8u112 to 8u32 - done
	* 7u80 to 7u76 - done
	* 6u45 to 6u34 - done
	* 5u20 to 5u22 - done
* Upgrades - in place between major versions (multiTenancy => false)
	* 5 to 6 - done
	* 5 to 7 - done
	* 5 to 8 - done
	* 6 to 7 - done
	* 6 to 8 - done
	* 7 to 8 - done
* Downgrades - between major versions (multiTenancy => false)
Alternatives fails to remove the old entries.
	* 8 to 7 - done
	* 7 to 6 - done
	* 8 to 6 - done
	* 6 to 5 - done
	* 7 to 5 - done
	* 8 to 5 - done
* reinstalling
	* a rerun of puppet will reinstall your JDK, this is because the JDK is uninstalled via **rpm** to ensure that the previous update version is removed as the puppet rpm provider installs Java multiple times per major version from Java 8 onwards. 		
* Set defaults via alternatives
	* Java 5
	* Java 6
	* Java 7
	* Java 8 