# ufw #

This is the ufw module. It provides...
The "Uncomplicated Firewall" (UFW) functionality.

## Current Status / Support
* Works on Ubuntu 
* Allows for multiple uses to define multiple port exemptions 
* Can provide a port exemption for `TCP` or `UDP`

## Usage
To set a *TCP* port exemption add the following to the manifest:  

	ufw {"test":
    	port => '8080',
    	isTCP => true
	}
For UDP we simply set the **isTCP** value to `false`:
	
	ufw {"test":
    	port => '8080',
    	isTCP => false
	}
## Testing performed

## Known Issues
[Known Issues Ubuntu](#Known_issues_ubuntu)


## Ubuntu
### <a href="Known_issues_ubuntu>Known Issues Ubuntu</a>
Makes the assumption that UFW is installed as a service on Ubuntu.  
If another firewall is being used such as iptables then this module will not install ufw and set it up as a service.

Behavioural issues:  
* Changing a rule via a manifest will **not** remove an old rule.  
* Currently cannot remove rules

### Adding a new version of Ubuntu  
## To Do
* Add ability to set port ranges instead of just a single port per manifest call
* Support removal of rules
* Support blocking of all ports by default, so that when an exemption is modified the old rule will be blocked?