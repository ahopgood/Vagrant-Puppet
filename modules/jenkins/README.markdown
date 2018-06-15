# jenkins #

This is the jenkins module. It provides...
a standalone jenkins instance

The module can be passed the following parameters as Strings:
* major_version, e.g. "2"
* minor_version, e.g. "19"
* patch_version e.g. "1"
* perform_manual_setup boolean, defaults to false to allow for installation from a backup location, true will create a new installation
* password_bcrypt_hash, a bcrypt hash of the admin password to be set, requires bcrypt 2a and a cost factor of 10.
* plugin_backup_location, the location of the backed up plugin archives and the plugin manifest file
* $job_backup_location, the location of the job backups
The module will default to 2.19.1.

Modules supported/available:  
* [Seed job module](#seedjob)
* [Git credentials module](#gitCredentials)
* [Java module](#java)
* [Maven module](#maven)
* [Jenkins Cli](#jenkins-cli)
    * [Configuration reload](#conf-reload)

## Current Status / Support
Supports:
* Ubuntu 15.10 (wily)

### Known Issues
**64-bit support only**  
[CentOS Known Issues](#CentOS_known_issues)  
[Ubuntu Known Issues](#Ubuntu_known_issues)  

Some modules (gitCredentials) require the `hiera` class.  
Currently this has two impacts:
 1. The hiera config file needs to be specified as `puppet apply --parser=future --hiera-config=/etc/puppet/hiera.yaml init.pp` to override the default of `~/.puppet/hiera.yaml`.
 2. It will require **two** runs of the manifest to ensure that the hiera files are generated in the correct location.  
At some point in the future this will be broken out into a separate manifest call to be run prior as a setup step.  

### Credentials.xml
How is the github token encrypted?
Using a secret specific to the jenkins install.
If the token cannot be decrypted then Jenkins will assume that the token is in plaintext and will encrypt it.
  
## Usage
First time manual setup can be declared via the *jenkins* class:
```
	class {'jenkins':
      perform_manual_setup => true,
      plugin_backup => "/vagrant/backup/test/",
    }
```
The `plugin_backup` location is where the back up script will store the plugin archives and the generated plugins.txt.

Automatic setup from a previous backup:
```
	class {'jenkins':
      perform_manual_setup => false,
      plugin_backup => "/vagrant/backup/test/",
    }
```

Job backup script:  
```
    jenkins::backup_jobs{"backup-script":}

```
Job backup script on a crontab:
```
    jenkins::backup_jobs{"backup-script":
        cron_hour => "19",
        cron_minute => "24",
        job_backup_location => "/home/vagrant/backups/"
    }
```
### Ubuntu Scripts
Back up and restore functionality is provided by a series of local scripts:
* `/usr/local/bin/retrieve-all-plugins.sh` will parse the `plugins.txt` from a backup location and loop through each line trying to restore a plugin.
    * **Param 1.** Backup location directory, the location where `plugins.txt` and the optional plugin files (.jpi/.hpi) are located
    * **Param 2.** Restore location directory, the location that the plugins will be restored to.
    * The `plugins.txt` file is read and each line is broken down into a plugin name, version and hash.
    * If there is a file in the restore location that matches the hash it is restored locally.
    * If there is no file or the hash doesn't match then the version of the plugin is retrieved from the jenkins plugin centre using the `retrieve-plugin.sh` script.
    * If there is no hash then the plugin is downloaded as is from the jenins plugin centre using the `retrieve-plugin.sh` script.
    * If the downloaded file doesn't match the hash (if provided) then an error is thrown
* `/usr/local/bin/retrieve-plugin.sh` is used to restore a single plugin:version:hash string value, this will check for a local version with a matching hash first and then resort to the plugin centre. If no version is provided it will pull the latest version of the plugin by default.
    * **Param 1.** Plugin name
    * **Param 2.** (Optional) Plugin version, defaults to "LATEST"
    * **Param 3.** (Optional) Download destination directory, defaults to current directory
    * This script when provided with a plugin name will check the jenkins plugin centre to see if the plugin is a .jpi/.hpi file extension and then retrieve it.
* `/usr/local/bin/backup-plugins.sh` is present in both manual and automatic install (in case of the need for a manual backup) and will trigger every five minutes via cron on the manual install.
    * **Param 1.** Directory location to backup to.
    * Will take all plugin .jpi/.hpi files found in */var/lib/jenkins/plugins/* and back them up to the specified location.
    * For each one it will calculate the hash, version number and name for each and write to the `plugins.txt` file which is used for restoration.  
* `/usr/local/bin/backup-jobs.sh` is a separate dependency that is used to copy the jobs folder (but not the config.xml) for each job to a tarred and gzipped archive, it can be scheduled as a cron job.
    * **Param 1.** Directory location to backup to.
    * **Param 2.** (Optional parameter) Directory location to backup the jobs from; defaults to */var/lib/jenkins/jobs/*
* `/usr/local/bin/restore-jobs.sh` is present in the automatic install to ensure that job history is restored on startup.
    * **Param 1.** Directory location of the dated *YYYY-mm-DD-HHMMSS.tar.gz* backup files
    * **Param 2.** (Optional parameter) Directory location to restore the jobs to; defaults to */var/lib/jenkins/jobs/* 
## Testing performed:
* Install on a fresh system with a manual install
	* Ubuntu 15.10
* Install on a fresh system with an install from a backup of the plugins
    * Ubuntu 15.10
* Install on a fresh system with an install from a backup of the jobs
    * Ubuntu 15.10

## Ubuntu
### <a name="Ubuntu_known_issues">Ubuntu known issues</a>

### <a namme="Debian_file_naming_conventions">Debian File naming conventions</a>
Currently there is no enforced naming conventions beyond the following:
`jenkins_<major-version>_<minor-version>-<patch-version>_all.deb`.
### Adding compatibility for other Ubuntu versions
### Adding new major versions of Jenkins

### Useful to know
[Job/Script security](https://github.com/jenkinsci/job-dsl-plugin/wiki/Script-Security) with the Jobs DSL

<a name="modules"></a>
## Modules
* [seed job module](#seedjob)
* [git credentials module](#gitCredentials)
* [java module](#java)
* [maven module](#maven)
* [Jenkins Cli](#jenkins-cli)
    * [Configuration reload](#conf-reload)

<a name="seedjob"></a>
### jenkins::seed_job module
This module provides the ability to specify a seed job defined in the [Jenkins job DSL](https://github.com/jenkinsci/job-dsl-plugin) formerly known as the netflix jenkins dsl.  
It takes two parameters:
* github_dsl_job_url - the repo url,
* github_credentials_name - the name of the jenkins credentials to use for github,

The module will create a jenkins job that triggers at 04:00.  
It will check out the specified project and execute **all** groovy files located within it.  
It will run only on the master branch.  
It is up to the person using this module to ensure that the groovy scripts are valid for creating other jobs.  

This module will **disable** global groovy job security via the *GlobalJobDslSecurityConfiguration.xml* configuration file.  
#### Requirements
Requires the [jenkins::gitCredentials](#gitCredentials) module to be configured and the name the credentials are saved as is used as a parameter for this module.  
Requires the [augeas::formatXML](../augeas/README.markdown#formatXML) module for sane xml formatting.   
Plugin support: job-dsl@1.66, git@3.7.0.

<a name="gitCredentials"></a>
### jenkins::gitCredentials module
Has two parameters:
* (optional) git_hub_api_token - the developer token used to checkout and commit on behalf of the seed job, 
    * It is recommended to *exclude* this param and allow this to be pulled from the `hiera` class using the key `hiera('jenkins::gitCredentials::git_hub_api_token','test')` instead of storing the sensitive data in the manifest.
    * Command line usage `puppet apply --parser=future --hiera-config=/etc/puppet/hiera.yaml init.pp`
    * The inclusion of the hiera class will require a run of the `hiera.pp` manifest first to ensure the hiera files are present and configured correctly. 
* token_name - the name these credentials will be referenced by
#### Requirements
Requires the [augeas::formatXML](../augeas/README.markdown#formatXML) module for sane xml formatting.
Requires the [hiera] module to pull in the token value from the common.yaml file.  
Plugin support: credentials@2.1.6

#### TODO
* Encrypt the token via eyaml 

<a name="java"></a>
### jenkins::global::java_jdk module
Allows for global configuration of a specified Java Development Kit (JDK) in the global configuration file `/var/lib/jenkins/config.xml`, useful to allow for multiple build capabilities, e.g. Java 1.6 and 1.7 side by side.  

* major_version - the major java version
* update_version - the update version
* appendNewJdk - a boolean; if true will append this entry to the Jdks configuration section, if false will wipe out Jdks and place the current entry in there.   

This will generate a globally named JDK in the following format: `1.${major_version}.0_${update_version}` which can then be referenced by your jobs.    
If adding multiple entries, the first should have `appendNewJdk = false` will all subsequent values being true.  
#### Support
* Ubuntu 15.10
#### Requirements
Requires the [augeas::formatXML](../augeas/README.markdown#formatXML) module for sane xml formatting.  
Requires the [Java module](../java/README.markdown), assumes that Java is installed to `/usr/lib/jvm/jdk-${major_version}-oracle-x64/`.  

<a name="maven"></a>
### jenkins::global::maven module
Allows for global configuration of a specified maven version in the `hudson.tasks.Maven.xml` within jenkins.  
* major_version - maven major version
* minor_version - maven minor version
* patch_version - maven path version

Will generate a globally named maven entry in the following format: `Maven-${major_version}-${minor_version}-${patch_version}` allowing for reference by your jobs.  

#### Support
* Ubuntu 15.10  
* Only major versions of maven can be specified (e.g. maven2, maven3 etc), a restriction/limitation of the maven module requirement
#### Requirements
Requires the [augeas::formatXML](../augeas/README.markdown#formatXML) module for sane xml formatting.    
Requires maven to be installed via the [maven module](../maven/README.markdown), assumes maven is installed to `/usr/share/maven*` where * is the major version.    
#### To do
* Remove granularity on maven - that way jobs only require a major version, would increase longevity.
* Granularity only required if asked for, e.g. can then create a specific version for a particular job

<a name="jenkins-cli"></a>
### Jenkins Cli 
Currently the `jenkins::global::reload::config` definition makes use of the `jenkins-cli.jar`.  
If other cli calls are required then the file resource for the jar could be turned into a virtual resource to prevent dependency conflicts.  
The exec call to the cli jar can also be generalised within its own module `jenkins::cli` to template calls to the cli.  

Supported calls:
* [Configuration Reload](#config-reload)

#### To Do
* Move the cli jar file to a virtual resource so it doesn't clash with multiple declarations
* Create a sub definition for calling the cli so that other calls can be supported via the cli.

<a name="config-reload"></a>
#### Configuration Reload
Allows for the Jenkins configuration to be reloaded with having to restart jenkins, useful for configuration file changes 
such as adding labels to a node.  

```
jenkins::global::reload::config{"set labels":}
```
or using a different account to trigger the reload:
```
jenkins::global::reload::config{"set labels":
    username => "test",
    password => "test"
}
```
#### Support
* Ubuntu 15.10  
#### Requirements
* Java needs to be present in the `/usr/bin/` location.
* The admin username needs to be stored either in hiera under the key `jenkins::admin::password::plaintext` or passed as a parameter

## ToDo
### CentOS
### Ubuntu
* Create a credentials.xml file for adding our github token. Need to provide a credentials version from our plugin file
* **done** Create a directory for the seed job in the jobs folder where the folder name is the job name
* **done** Create a config.xml file
* **done** xmlstarlet -> create a definition for pretty_print to allow for reuse.
* Move httpd header augeas type definition into the augeas class
* extend augeas definition to allow for pretty print
* Change the seed job module to trigger the build on creation and on commit to master.
### Notes