# Certbot

This is the certbot module. It provides... [Certbot support](https://certbot.eff.org/)  
  
## Current Status / Support
Tested to work on the following operating systems:
* Ubuntu 18.04 - 


### Known Issues  
**64-bit support only**  
[Ubuntu Known Issues](#Ubuntu_known_issues)

## Usage 
Can be declared via the 
## Dependencies

## Testing performed:
* Install on a fresh system

## Ubuntu
### <a href="Ubuntu_known_issues">Ubuntu known issues</a>

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
* Add support for installing certbot
* Externalise python3 dependencies
* Move python2 shared dependencies into virtualised resources
* Add support for obtaining certificates if not present
* Add support for renewal 
