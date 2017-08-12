# Sudo
## Current Status / Support
Support for the following operating systems:
* Ubuntu 15.10
* CentOS 6
* CentOS 7

## Known Issues
* Currently only supports adding sudo privileges for a user, not removal.  
* Cannot be declared / used more than once; only supports sudo for a single user as a consequence.
* [Known Issues Ubuntu](#Known_issues_ubuntu)  
* [Known Issues CentOS](#Known_issues_centos)  

## Usage
```
class {"sudo":
    username => "bob",
}
```

### Dependencies
A [user resource](https://docs.puppet.com/puppet/latest/types/user.html) for the specified username is a required resource. 


## Testing performed
Works on clean installs of:
* Ubuntu 15.10
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
* Add support for multiple declarations of sudo module for multiple users
* Add removal of sudo privileges for a specified user