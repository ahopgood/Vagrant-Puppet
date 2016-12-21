## Centos Test Run
* Install single JDK on fresh system
	* Java 5 - done
	* Java 6 - done
	* Java 7 - done
	* Java 8 - done
* Multi tenancy JVMs, i.e. 7 running alongside 8
	* Currently installs major versions alongside each other
	* Update versions are automatically upgraded
	* Multi tenanted JVMs can now be specified in a single puppet manifest using multiple defines sections instead of multiple runs to install the JVMs next to each other.
* Upgrades - in place between major versions (multiTenancy => false)
	* 5 to 6
	* 6 to 7
	* 7 to 8
	* 6 to 8
* Upgrades - in place between update versions with the same major version
	* 8u32 to 8u112
	* 7u76 to 7u80
	* 6u34 to 6u45
	* 5u22 to 5u
* Downgrades - between major versions (multiTenancy => false)
	* 8 to 7
	* 7 to 6
	* 8 to 6
	* 6 to 5
* Downgrades - between update versions with the same major version
	* 8u112 to 8u32
	* 7u80 to 7u76
	* 6u45 to 6u34
* reinstalling - Ubuntu specific currently
	* a rerun of puppet will reinstall your JDK, this is because the JDK is uninstalled via **dpkg** to ensure that the previous update version is removed as the puppet dpkg  provider cannot remove with a specific version, it works only with a generic package name e.g. oracle-java6-jdk 		
* Set defaults via alternatives
	* Java 5
	* Java 6
	* Java 7
	* Java 8 