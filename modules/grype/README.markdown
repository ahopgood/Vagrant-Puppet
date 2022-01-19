# Grype

This is the Grype module. It provides... [grype](https://github.com/anchore/grype/) as a binary

The module can be passed the following parameters as Strings:  
* 
  
## Current Status / Support
Tested to work on the following operating systems:
* Ubuntu 16.04
* Ubuntu 18.04

### Known Issues  
**64-bit support only**  

[Ubuntu Known Issues](#Ubuntu_known_issues)

## Usage 
/tests/init.pp to user default version:
```
$local_install_path = "/etc/puppet/"
$local_install_dir  = "${local_install_path}installers/"
file {
  "${local_install_dir}":
    ensure => directory,
}

include grype
```
/tests/versioned.pp to override default versions:
```
$local_install_path = "/etc/puppet/"
$local_install_dir  = "${local_install_path}installers/"
file {
  "${local_install_dir}":
    ensure => directory,
}

class { "grype":
  major_version => "0",
  minor_version => "29",
  patch_version => "0"
}
```

Running via puppet:
```
sudo puppet apply --modulepath=/etc/puppet/modules/ /tests/init.pp
```

## Dependencies

## Testing performed:
* Install on a fresh system
	* Ubuntu
	
## Ubuntu
### <a href="Ubuntu_known_issues">Ubuntu known issues</a>


### <a href="Debian_file_naming_conventions">Debian File naming conventions</a>
The *.deb* files with the appropriate `grype_major.minor.patch_linux_amd64` naming scheme grype_0.31.1_linux_amd64) need to be located in the **files/Ubuntu/15.10** folder for the passed parameters to allow for installation of the correct grype version.  

### Adding compatibility for other Ubuntu versions
### Adding new major versions of grype

## ToDo
