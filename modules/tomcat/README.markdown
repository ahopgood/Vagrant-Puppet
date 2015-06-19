# tomcat #

This is the tomcat module. It provides...

* A Tomcat user
* A Tomcat user group
* A GUI manager user
	* Username can be passed as a module parameter
		* If username is not present then no user is created
	* Password can be passed as a module parameter
		* If password is not present then no user is created
* A path can be passed in as a module parameter to create a symbolic link to the logs directory
* Sets JAVA_HOME via java.sh in /etc/profile.d
* Sets CATALINA_HOME via catalina-home.sh in /etc/profile.d
* Creates a tomcat service file in /etc/init.d (chkconfig set to ensure the service starts on start up)
* Ensures the service starts
* Requires the Java module by the same author. 
* A port number can be passed as a module parameter.
* Create an iptables firewall rule for a specified port parameter
* Only tested to work on CentOS
* Supports multiple major versions of tomcat 
	* 6.0.xx, 7.0.xx and 8.0.xx
	* Cannot support multiple minor versions of tomcat on same install
* Performs upgrades of minor versions of existing installations 
* Script manager user
	* Username passed as a module parameter
		* If username is not present then no user is created
	* Password passed as a module parameter
		* If password is not present then no user is created
* Can pass in the install location as a module parameter
	* Defaults to /var/hosting/tomcatx if parameter is not present
	* Symbolic link from /var/log/tomcatx to /var/hosting/tomcatx/logs
	* Symbolic link from /usr/bin/tomcatx to /var/hosting/tomcatx/bin

Features to be implemented:
* Have vm args set in the setenv.sh file
* Enable proxying via tomcat args
** Http address as a module parameter
** Not set if not a module parameter
** Https address as a module parameter
** Not set if not a module parameter
* Have the tomcat service file start and stop tomcat as the tomcat user

##Errors##
###Tomcat script cannot be found, bash code 127###
This is due to the tomcat.erb file not being formatted in the unix filesystem.
Run a utility such as dos2unix to fix this.
