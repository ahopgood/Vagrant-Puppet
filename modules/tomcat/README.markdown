# tomcat #

This is the tomcat module. It provides...
* A Tomcat user
* A Tomcat user group
* A GUI manager user
** Username can be passed as a module parameter
** Password can be passed as a module parameter
* A path can be passed in as a module parameter to create a symbolic link to the logs directory
* Sets JAVA_HOME via java.sh in /etc/profile.d
* Sets CATALINA_HOME via catalina-home.sh in /etc/profile.d
* Creates a tomcat service file in /etc/init.d (chkconfig set to ensure the service starts on start up)
* Ensures the service starts
* Requires the Java module by the same author. 
* A port number can be passed as a module parameter.
* Create an iptables firewall rule for a specified port parameter
* Only tested to work on CentOS
* Supports only tomcat 6.0.xx and 7.0.xx
* Performs upgrades of minor versions of existing installations 
* Script manager user
** Username passed as a module parameter
*** If username is not present then no user is created
** Password passed as a module parameter
*** If password is not present then no user is created


Features to be implemented:
* GUI manager user
** Username passed as a module parameter
*** If username is not present then no user is created
** Password passed as a module parameter
*** If password is not present then no user is created

* Pass in the install location as a module parameter
** Default to /var/hosting/tomcat7 if parameter is not present
* Support multiple major versions of tomcat
** Cannot support multiple minor versions of tomcat on same install
* Have vm args set in the setenv.sh file
* Enable proxying via tomcat args
** Http address as a module parameter
** Not set if not a module parameter
** Https address as a module parameter
** Not set if not a module parameter
* Tidy up of expanded zip file -> place in /usr dir and not in main filesystem
* Tidy up of zip file