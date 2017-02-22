# unzip #

This is the unzip module. It provides...
The ability to unzip zip archives.

## Current Status / Support
Installs the unzip binary.  
64-bit support only.  

* CentOS 6 - unzip version 6.0 redhat patch version 2
* CentOS 7 - unzip version 6.0 redhat patch version 16


## Usage
```
class {"unzip":}
```

## Testing performed
* CentOS 6 - single call to class{"unzip":}
* CentOS 7 -

## Known Issues
[Known Issues Ubuntu](#Known_issues_ubuntu)
[Known Issues Ubuntu](#Known_issues_centos)

## Ubuntu
### <a href="Known_issues_ubuntu>Known Issues Ubuntu</a>

### Adding a new version of Ubuntu  

## CentOS

### <a href="Known_issues_centos">Known Issues CentOS</a>
* Being defined as a class manifest means that multiple definitions will cause a puppet error.

### Adding a new version of CentOS  
In order to add a new version of CentOS to this module you will need to place the appropriate **.rpm** installer in the CentOS/<major_verion>/ directory.  
The main manifest will require the addition of a new version check within the CentOS if conditional.  
Within this version check you will need to instantiate the **$platform** variable to match the trailing name of your installer file.   

## To Do
* Expand to include Ubuntu 15.10 support for version 6.0 of unzip
* Expand to allow for other versions of unzip to be used?
* Replace call in Kanboard & add dependency on `class{"unzip":}` to Kanboard module
* Add dependency within JCE definition, update test manifests
* Failure scenario for unsupported operating systems