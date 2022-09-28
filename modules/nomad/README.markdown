# Nomad

This is the Nomad module. It provides... [Nomad](https://www.nomadproject.io/) as a service

The module can be passed the following parameters as Strings to specify the install version:  
* `major_version => "1",`
* `minor_version => "2",`
* `patch_version => "6"`
  
## Current Status / Support
Tested to work on the following operating systems:
* Ubuntu 16.04
* Ubuntu 18.04

### Known Issues  
**64-bit support only**  

[Ubuntu Known Issues](#Ubuntu_known_issues)

## Usage 
/tests/init.pp to use default version:
```
$local_install_path = "/etc/puppet/"
$local_install_dir  = "${local_install_path}installers/"
file {
  "${local_install_dir}":
    ensure => directory,
}

include nomad
```
/tests/versioned.pp to override default versions:
```
$local_install_path = "/etc/puppet/"
$local_install_dir  = "${local_install_path}installers/"
file {
  "${local_install_dir}":
    ensure => directory,
}

class { "nomad":
  major_version => "1",
  minor_version => "2",
  patch_version => "6"
}
```

Running via puppet:
```
sudo puppet apply --modulepath=/etc/puppet/modules/ /tests/init.pp
```
## Sub-modules
### Levant
#### Usage 
/tests/levant.pp to use default version:
```
$local_install_path = "/etc/puppet/"
$local_install_dir  = "${local_install_path}installers/"
file {
  "${local_install_dir}":
    ensure => directory,
}

nomad::levant{"install":}
```

## Testing performed:
* Install on a fresh system
	* Ubuntu 16
	* Ubuntu 18
	
## Ubuntu
### <a href="Ubuntu_known_issues">Ubuntu known issues</a>
Obtaining levant archives requires curl:
```
LEVANT_ARCHIVE="levant_${LEVANT_VERSION}_linux_amd64.zip"
curl -L -o ${LEVANT_ARCHIVE} https://releases.hashicorp.com/levant/${LEVANT_VERSION}/levant_${LEVANT_VERSION}_linux_amd64.zip
sudo unzip ${LEVANT_ARCHIVE} -d /usr/bin
```
### <a href="Debian_file_naming_conventions">Debian File naming conventions</a>
The *.deb* files with the appropriate `nomade_major.minor.patch_amd64` naming scheme nomad_1.2.6_amd64) need to be located in the **files/Ubuntu/15.10** folder for the passed parameters to allow for installation of the correct nomad version.  

### Adding compatibility for other Ubuntu versions
### Adding new major versions of nomad
## ToDo
