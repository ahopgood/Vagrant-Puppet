# httpd / Apache2

This is the httpd module. It provides... [httpd / Apache2 functionality](https://httpd.apache.org/)

The module can be passed the following parameters as Strings:  
* Major version number, e.g. "2"
* Minor version number, e.g. "4"
* Patch version number e.g. "14"
  
## Current Status / Support
Tested to work on the following operating systems:
* CentOS 6 - Apache 2.2.15, **it is advisable to move on from CentOS 6 - these repositories are no longer being updated**
* CentOS 7 - Apache 2.4.6

### Known Issues  
**64-bit support only**  
[CentOS Known Issues](#CentOS_known_issues)  
[Ubuntu Known Issues](#Ubuntu_known_issues)  

## Usage 
Can be declared via the *httpd* class:
	
	class{"httpd":}
	
or directly via the *httpd::ubuntu* class:

	class {"httpd::ubuntu":
	  major_version => "2",
	  minor_version => "4",
	  patch_version => "12",
	}

or directly via the *httpd::centos* class:
	
	class{httpd::centos":
	  httpd_user => "httpd", 
	  httpd_group => "httpd",
	}	   
## Dependencies
* iptables module is required [raw readme here](../iptables/README.markdown)
* Port exception added for `port 80` to ensure http traffic can get through to the HTTP server

## Testing performed:
* Install on a fresh system
	* CentOS6
	* CentOS7
	
## CentOS
Installs apache to the following locations:
* `/usr/sbin/httpd` executable file
* `/var/log/httpd/` logging directory
* `/etc/httpd/` main application directory
* `/etc/httpd/conf/` configuration directory
* `/etc/httpd/conf/httpd.conf` main configuration file for apache web server 
* `/var/www/html/` default document root for serving web pages

### CentOS6
Command line service calls are as follows:  
* `sudo /etc/init.d/httpd start` to start the service
* `sudo /etc/init.d/httpd stop` to stop the service
* `sudo /etc/init.d/httpd restart` to restart the service
* `sudo /etc/init.d/httpd status` to get the current status of the service

### CentOS7
Command line service calls are as follows:
* `sudo systemctl start httpd` to start the service
* `sudo systemctl stop httpd` to stop the service
* `sudo systemctl restart httpd` to restart the service
* `sudo systemctl status httpd` to get the current status of the service

### <a href="CentOS_known_issues">Known issues</a>
* CentOS 6 is on a very out of date version of apache (2.2.15), the repositories for this version of CentOS are no longer being updated.

### <a href="CentOS_file_naming_conventions">CentOS file naming conventions</a>
The *.rpm* files with the appropriate minor-major numbers need to be located in the **files/CentOS/6** folder for the passed parameters to allow for installation of the correct apache httpd version.  
Ensuring this pattern is followed will allow the module to locate files correctly, it was decided not to rename all the rpms into a common naming structure since this places the onus on the person running the module to rename files every time there is an update.  

This decision may be revisited in future in order to simplify the module if the Apache foundation continue to change their naming scheme.  
### Adding compatibility for other CentOS versions
Ensure that a new directory is present in the /file/CentOS/* directory named after the new version of CentOS and ensure the apache installer is present.    
For the **existing** dependencies if they are still applicable then you need to add them to the new version directory.   
You will also need to add these new file names/versions to the main **centos.pp** manifest and include a new condition to resolve for your version of the OS.  

	$apr_file = $os ? {
    	'CentOS7' => "apr-1.4.8-3.el7.x86_64.rpm",
    	'CentOS6' => "apr-1.3.9-5.el6_2.x86_64.rpm",
    	default => undef,
	}

For the apr library cecomes the following for CentOS 8:  


	$apr_file = $os ? {
    	'CentOS7' => "apr-1.4.8-3.el7.x86_64.rpm",
    	'CentOS6' => "apr-1.3.9-5.el6_2.x86_64.rpm",
		'CentOS8 => "apr-1.5.1-2-el8.x86_64.rpm",
    	default => undef,
	}


If there are **new** dependencies then you'll need to add their installers to the **/files/CentOS/x/** folder where x is the CentOS version and you'll need to create a whole new conditional resolution for the library name, similar to the **apr** example above to ensure that name resolves correctly.  
As well as name resolution you'll also need to add a conditional section based on the OS version to actually obtain the installer file and then install the package, an example for the apr installer is found below:  

	file{
    	"${local_install_dir}${apr_file}":
    	ensure => present,
    	path => "${local_install_dir}${apr_file}",
    	source => ["puppet:///${puppet_file_dir}${apr_file}"]
	}
	package {"apr":
    	ensure => present,
    	provider => 'rpm',
    	source => "${local_install_dir}${apr_file}",
    	require => File["${local_install_dir}${apr_file}"]
	}


All dependencies and the actual Apache installer itself are best obtained by running `yumdownloader <installername>` on the target CentOS version, sometimes this will require `sudo apt-get install yum-utils` to be installed first.  

### Adding new major versions of Apache
Ensure that the .rpm installer is present in the */file/CentOS/* directory under the correct version of CentOS.  
The installer will need to follow the same naming conventions as found in [CentOS file naming conventions](CentOS_file_naming_conventions) section.  
If the dependencies change between versions then a new conditional section will need to be added to include these dependencies for your specific version of Apache.  

## Ubuntu
### <a href="Ubuntu_known_issues">Ubuntu known issues</a>
* Ubuntu support is still under development

### <a href="Debian_file_naming_conventions">Debian File naming conventions</a>
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
* Increase supported Apache versions from the current least supported version of this module to the most current version released in the OS's repository:  
	* CentOS6 current - 2.2.15 this is the latest in the CentOS6
	* CentOS7 - 2.4.6  
	* Ubuntu - 2.4.12
* Ubuntu support
* Raspberian support
* Terry Pratchett x-clacks header
* Virtual Host configuration
* SSL Configuration
* Custom error pages; 404, 401, 403, 500 etc
* Removal of Operating System information from error pages 
* Removal of apache version information from error pages
* Have all files saved to `/etc/puppet/installers/httpd/`
* In the case of an upgrade from one version of apache to another, remove old package files from `/etc/puppet/installers/httpd` folder
