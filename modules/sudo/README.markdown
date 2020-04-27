# Sudo
## Current Status / Support
Support for the following operating systems:
* Ubuntu 16.04
* Ubuntu 15.10
* CentOS 6
* CentOS 7

## Known Issues 
* [Known Issues Ubuntu](#Known_issues_ubuntu)  
* [Known Issues CentOS](#Known_issues_centos)  

## Usage
Adding to sudo
```
sudo {"bob":}
```

Removing sudo privileges
```
sudo::remove {"bob":}
```

### Dependencies
For adding sudo privileges a [user resource](https://docs.puppet.com/puppet/latest/types/user.html) for the specified username is a required resource. 

## Testing performed
Works on clean installs of:
* Ubuntu 15.10
* Ubuntu 16.04
* Ubuntu 18.04
* CentOS 6
* CentOS 7

## CentOS
Installs sudo privileges to the `/etc/sudoers.d/` directory in a single file based on the username.

<a name="Known_issues_centos"></a>
### Known Issues CentOS

## Ubuntu
Installs sudo privileges to the `/etc/sudoers.d/` directory in a single file based on the username.

<a name="Known_issues_ubuntu"></a>
### Known Issues Ubuntu

## To Do
* Add finer grained control of sudo privileges, currently we're all in with no compromises.