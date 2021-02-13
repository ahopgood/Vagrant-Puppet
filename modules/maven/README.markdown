# Maven
Supports Ubuntu:
 * 15.10
 * 16.04
 * 18.04  

Currently only support major version multiple tenancy, e.g. maven 2 side by side with maven 3.

## Repository Module
The repository directory is a **require** clause for both `settings.xml` and `settings-security.xml`
```
maven::repository {"vagrant repository":
  user => "vagrant"
}
```
It is **strongly** recommended you use hiera **and** eyaml to look and encrypt/decrypt (respectively) the passwords you use for maven.   
### Settings.xml
The `maven::repository::settings` allows for the generation of the settings.xml file in the `~/.m2/` repository directory for the specified user.  
The module will populate a template with values for:
* a `central` and a `snaphots` server entries containing the `username` and `password` for the remote repository servers
* a maven profile for `artifactory`, activated by default
* a `central` and a `snaphots` repository entries, these map to use the credentials found in the above servers
* a `central` and a `snaphots` plugin repository entries, these map to use the credentials found in the above servers
```
maven::repository::settings {"vagrant settings":
  user => "vagrant",
  password => "test",
  repository_name => "reclusive-repo",
  repository_address => "https://artifactory.alexanderhopgood.com/artifactory/reclusive-repo",
}
```
### Settings-Security.xml
The `maven::repository::settings::secruity` allows for the generation of the settings-security.xml file in the `~/.m2/` repository directory for the specified user.
The module will populate a template with a value for the master password used to encrypt user/server passwords in the regular `settings.xml` file.
```
maven::repository::settings::security {"vagrant settings security":
  user => "vagrant",
  master_password => hiera('maven::repository::settings::security::master_password',''),
}
```
## To Do
* Improve readme
    * Information on alternatives support
    * Installation location
    * Requires Java
    * How to check installation `mvn --version`
    * .m2 location and settings.xml
* Support for minor and patch version granularity side by side
* Support to specify a default for a major version

# Dev notes
## Installing manually  
`sudo tar -xvzf apache-maven-3.3.9-bin.tar.gz`  
`mv apache-maven-3.3.9 /usr/lib/mvn/apache-maven3.3.9`  

Set the following environment variables M2_HOME, M2, MAVEN_OPTS:
`export M2_HOME=/opt/maven`  
`export PATH=${M2_HOME}/bin:${PATH}`  

You can save these variables to the profile.d directory to run automatically every time a shell is used:  
`sudo nano /etc/profile.d/mavenenv.sh`  

## Installation of maven via Ubuntu
`apt-get install maven2`  
Puts the contents of maven tar.gz into /usr/share/maven
```
ls -l /usr/share/maven
bin
boot
conf -> /etc/maven
lib
man
```
and puts the configuration into 
```
ls -l /etc/maven
m2.conf
settings.xml
```
The m2.conf is a symbolic link from /usr/share/maven -> /etc/maven

## Java style installation, using alternatives and default directories
Java `/usr/bin/java -> /etc/alternativies/java -> /usr/lib/jvm/jdk-8-oracle-x64/jre/bin/java`  
Mvn `/usr/bin/mvn -> /etc/alternatives/mvn -> /usr/lib/mvn/apache-maven-3.0.5/bin/mvn`  

Main installation of maven 3 -> /usr/share/maven3/  
$M2_HOME=/usr/share/maven3/  
Do we need the M2_HOME values if we already have alternatives?  
Where would the .m2 folder live with the local repositories?  