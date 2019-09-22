# iptables #

This is the iptables module.

Currently tested on the following platforms:
* CentOS 6 
* CentOS 7

##Testing
###CentOS 6
###CentOS 7
CentOS 7 changed from iptables to firewalld for its default firewall.
Verify that firewalld is disabled / stopped:  
`systemctl status firewalld`  

Ensure that the rule for your <port> value that you're testing is in the iptables config:  
`iptables --list-rules | /bin/grep -- <port>`  

Restart the machine to verify that the rule has been persisted:
`sudo shutdown -r`  
followed by:  
`iptables --list-rules | /bin/grep -- <port>`   

## Ubuntu
Currently Ubuntu does not make use of iptables as its main firewall service.  
This means iptables is available but there is no provision for it to run as a service making configuring iptables in Ubuntu redundant.  
Make use of the `ufw` module instead.