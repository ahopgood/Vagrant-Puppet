# ddclient

This is the ddclient module. It provides... [ddclient functionality](https://sourceforge.net/p/ddclient/wiki/Home/)

The module can be passed the following parameters as Strings:  
* 
  
## Current Status / Support
Tested to work on the following operating systems:
* CentOS 6 - 3.8.3
* CentOS 7 - 3.8.3
* Ubuntu 15 - 3.8.3 

Currently only support the following dynamic dns providers:
* namecheap dns

### Known Issues  
**64-bit support only**  
Currently the module cannot parse a default provided `ddclient.conf` file due to the complexity and commented examples.  
Instead a new ddclient.conf file needs to be created for this module to manage it.  

[CentOS Known Issues](#CentOS_known_issues)  
[Ubuntu Known Issues](#Ubuntu_known_issues)

## Usage 
Can be declared via the *ddclient* class:
	class {"ddclient":}
Entries are declared via the *ddclient::entry* definition.
```
    define ddclient::entry(
      $protocol = undef,
      $use = undef,
      $ssl = undef,
      $server = undef,
      $login = undef,
      $password = undef,
      $domains = undef,
      $remove_package_conf = false,
    )
```
* **remove_package_conf** will remove the existing installed ddclient.conf file and implement a new one based on the entries provided. 

## Dependencies
* A Domain Name System (DNS) provider/registrar that supports dynamic DNS.
* Account details from said DNS provider/registrar
* The `augeas` class is required to ensure that entries can be added to the `ddclient.conf` file.

## Testing performed:
* Install on a fresh system
	* CentOS6
	* CentOS7
	* Ubuntu
	
## CentOS
Installs ddclient to the following locations:
* `/etc/ddclient.conf` the configuration file

### CentOS6
Command line service calls are as follows:  
* `/etc/init.d/ddclient start`
* `/etc/init.d/ddclient restart`
* `/etc/init.d/ddclient stop`

### CentOS7
Command line service calls are as follows:
* `service ddclient start`
* `service ddclient restart`
* `service ddclient stop`

### <a href="CentOS_known_issues">Known issues</a>
* 

### <a href="CentOS_file_naming_conventions">CentOS file naming conventions</a>
The *.rpm* files with the appropriate `major.minor.patch-ospatch.el<os_ver>` naming scheme (e.g. 3.8.3-1.el6 for CentOS 6) need to be located in the **files/CentOS/6** folder for the passed parameters to allow for installation of the correct ddclient version.  
Ensuring this pattern is followed will allow the module to locate files correctly, it was decided not to rename all the rpms into a common naming structure since this places the onus on the person running the module to rename files every time there is an update.  

This decision may be revisited in future in order to simplify the module if the ddclient team continue to change their naming scheme.  
### Adding compatibility for other CentOS versions
Ensure that a new directory is present in the /file/CentOS/* directory named after the new version of CentOS and ensure the apache installer is present.    
For the **existing** dependencies if they are still applicable then you need to add them to the new version directory.   
You will also need to add these new file names/versions to the main **init.pp** manifest and include a new condition to resolve for your version of the OS.  

    if (versioncmp("${OS_version}", "7") == 0) {
      $ddclient_file = "ddclient-${major_version}.${minor_version}.${patch_version}-2.el7.noarch.rpm"
    } elsif (versioncmp("${OS_version}", "6") == 0) {
      $ddclient_file = "ddclient-${major_version}.${minor_version}.${patch_version}-1.el6.noarch.rpm"
    }

All dependencies and the actual Apache installer itself are best obtained by running `yumdownloader <installername>` on the target CentOS version, sometimes this will require `sudo apt-get install yum-utils` to be installed first.  

### Adding new major versions of ddclient
Ensure that the .rpm installer is present in the */file/CentOS/* directory under the correct version of CentOS.  
The installer will need to follow the same naming conventions as found in [CentOS file naming conventions](CentOS_file_naming_conventions) section.  
If the dependencies change between versions then a new conditional section will need to be added to include these dependencies for your specific version of Apache.  

## Ubuntu
### <a href="Ubuntu_known_issues">Ubuntu known issues</a>


### <a href="Debian_file_naming_conventions">Debian File naming conventions</a>
The *.deb* files with the appropriate `major.minor.patch-ospatch.<os_ver>` naming scheme ddclient_3.8.3-1.1ubuntu1_all) need to be located in the **files/Ubuntu/15.10** folder for the passed parameters to allow for installation of the correct apache2 version.  

### Adding compatibility for other Ubuntu versions
### Adding new major versions of Apache

## ToDo
* Add support for:
  * CentOS 6
  * CentOS 7
  * Ubuntu 15.10
* Update readme with informaiton on:
  * File format for centos
  * File format for ubuntu
  * Service calls for CentOS 6
  * Service calls for CentOS 7
  * Service calls for Ubuntu 15.10
  * Parameters required for ddclient entries 
  * Update support to include **only** namecheap
  * Update support to include version 3.8.3 of ddclient as it provides multiple domain support
  * Create a section for the ddclient lens
* Extract setup of ddclient entries to a define
  * Test multiple declarations of entries 
* Add comment support to the ddclient lens [see dealing with comments](https://github.com/hercules-team/augeas/wiki/Dealing-with-comments)
* Have lens setup in the ddclient class
* Create a define section in `augeas` class for supporting writing of lenses.
* Only run lens addition of ddclient entry if the entry doesn't already exist, unless changed.
* Move perl pieces to separate module
* Reset /etc/ddclient.conf permissions to something sensible (r+w owner only, ddclient owner & group)
* Pull lens development support pieces into the augeas module
* ddclient::entry name field used as the login unless specified otherwise