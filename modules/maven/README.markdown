# Maven

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