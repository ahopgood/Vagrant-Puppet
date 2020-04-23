# patch #

This is the patch module. It provides...

## Current Status / Support
Supports:
* CentOS 6
* Ubuntu
    * 15.10
    * 16.04
    * 18.04

### Known Issues
**64-bit support only**  
[CentOS Known Issues](#CentOS_known_issues)  
[Ubuntu Known Issues](#Ubuntu_known_issues)  

## Usage
```
include patch
```
Requires a directory `/etc/puppet/installers` to be present for the module to work.

## Testing performed

## CentOS
### <a name="CentOS_known_issues">CentOS known issues</a>
Only version 2.6-6 is supported on CentOS 6.
Only version 2.7.1-8 is supported on CentOS 7.

## Ubuntu
### <a name="Ubuntu_known_issues">Ubuntu known issues</a>
Only version 2.7.5-1 is supported on Ubuntu 15.10

## To Do
* **done** Support for CentOS 7
* **done** Support for Ubuntu 15
* **done** Test harness vagrant profiles
* Multi version support
* **done** File structure to reflect OS version