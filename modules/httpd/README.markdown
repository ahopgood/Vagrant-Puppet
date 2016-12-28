# httpd / Apache2

This is the httpd module. It provides... [Httpd / Apache2 functionality](https://httpd.apache.org/)

The module can be passed the following parameters as Strings:  
* Major version number, e.g. "2"
* Minor version number, e.g. "4"
* Patch version number e.g. "14"
  
## Current Status / Support
Tested to work on the following operating systems:
* CentOS 6
* CentOS 7

### Known Issues  
**64-bit support only**  
[CentOS Known Issues](#CentOS_known_issues)  
[Ubuntu Known Issues](#Ubuntu_known_issues)  

## Usage 
Can be declared via the *httpd* class:
	
	class{"httpd":}:
	
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
* Iptables module is required **provide link here**
* Port exception added for `port 80` to ensure http traffic can get through to the HTTP server

## Testing performed:
* Install on a fresh system
	* CentOS6
	* CentOS7
	
## CentOS
### CentOS6
Installs apache to the following locations:

Command line service calls are as follows:  
* `sudo /etc/init.d/httpd start` to start the service
* `sudo /etc/init.d/httpd stop` to stop the service
* `sudo /etc/init.d/httpd restart` to restart the service
* `sudo /etc/init.d/httpd status` to get the current status of the service

### CentOS7
Installs apache to the following locations:

Command line service calls are as follows:
* `sudo systemctl start httpd` to start the service
* `sudo systemctl stop httpd` to stop the service
* `sudo systemctl restart httpd` to restart the service
* `sudo systemctl status httpd` to get the current status of the service

### <a href="CentOS_known_issues">Known issues</a>
* 

### <a href="CentOS_File_naming_conventions">CentOS File naming conventions</a>
The *.rpm* files with the appropriate minor-major numbers need to be located in the **files/CentOS/6** folder for the passed parameters to allow for installation of the correct apache httpd version.  
Ensuring this pattern is followed will allow the module to locate files correctly, it was decided not to rename all the rpms into a common naming structure since this places the onus on the person running the module to rename files every time there is an update.  

This decision may be revisited in future in order to simplify the module if the Apache foundation continue to change their naming scheme.  
### Adding compatibility for other CentOS versions

### Adding new major versions of Apache


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
* Ubuntu support
* Raspberian support
* Terry Pratchett x-clacks header
* Virtual Host configuration
* SSL Configuration
* Custom error pages; 404, 401, 403, 500 etc
* Removal of Operating System information from error pages 
* Removal of apache version information from error pages

