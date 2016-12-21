# master_agent #

This is the master_agent module. It provides...

## Master
Need to map agent ip addresses to domain names for the master to be able to sign certificates.  
Master is a Certificate Authority (CA) and needs to sign certificate requests from agents.  


## Agents
Agents need to map the puppet master ip address to the puppet domain name.  
Agents need to submit a certificate signing request to the puppet master.  

## Problems
How to co-ordinate the agents and master ip-name pairs? 

Can I source the IPs and MACs from a single auto-generated file and then allocate to the master and agents on startup, running a script to alter the /etc/hosts file.

* Can vagrant files inherit?
* Can I pre-generate IPs & MACs?
* Is there a destroy hook to perform tidy up?
* Can I use ruby to manipulate a file?
	* register IPs and MACs
	* Deregister IPs and MACs
* Can two VMs share a file via synced folders?