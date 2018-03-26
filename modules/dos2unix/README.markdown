# dos2uniz

This is the dos2uniz module. It provides... [dos2uniz ]()

The module can be passed the following parameters as Strings:  
* 
  
## Current Status / Support
Tested to work on the following operating systems:
* Ubuntu 15 - 

### Known Issues  
**64-bit support only**  

[CentOS Known Issues](#CentOS_known_issues)  
[Ubuntu Known Issues](#Ubuntu_known_issues)

## Usage 

## Dependencies

## Testing performed:
* Install on a fresh system
	* Ubuntu
	
## CentOS

### CentOS6
### CentOS7

### <a href="CentOS_known_issues">Known issues</a>
 

### <a href="CentOS_file_naming_conventions">CentOS file naming conventions</a>
### Adding compatibility for other CentOS versions
### Adding new major versions of dos2uniz

## Ubuntu
### <a href="Ubuntu_known_issues">Ubuntu known issues</a>


### <a href="Debian_file_naming_conventions">Debian File naming conventions</a>
The *.deb* files with the appropriate `major.minor.patch-ospatch.<os_ver>` naming scheme ddclient_3.8.3-1.1ubuntu1_all) need to be located in the **files/Ubuntu/15.10** folder for the passed parameters to allow for installation of the correct apache2 version.  

### Adding compatibility for other Ubuntu versions
### Adding new major versions of dos2uniz

## ToDo
* Add support for:
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