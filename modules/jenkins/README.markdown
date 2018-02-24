# jenkins #

This is the jenkins module. It provides...
a standalone jenkins instance

The module can be passed the following parameters as Strings:
* major_version, e.g. "2"
* minor_version, e.g. "19"
* patch_version e.g. "1"
* perform_manual_setup boolean, defaults to false to allow for installation from a backup location, true will create a new installation
* password_bcrypt_hash, a bcrypt hash of the admin password to be set, requires bcrypt 2a and a cost factor of 10.
* backup_location
* plugin_backup, the location of the backed up plugin archives and the plugin manifest file
The module will default to 2.19.1.

## Current Status / Support
Supports:
* Ubuntu 15.10 (wily)

### Known Issues
**64-bit support only**
[CentOS Known Issues](#CentOS_known_issues)
[Ubuntu Known Issues](#Ubuntu_known_issues)

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

### Ubuntu
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
* Install on a fresh system with an install from a backup
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


## ToDo
### CentOS
### Ubuntu
* Create a credentials.xml file for adding our github token. Need to provide a credentials version from our plugin file
* Create a directory for the seed job in the jobs folder where the folder name is the job name
* Create a builds folder within the job folder
* Create a config.xml file
* Add /files/var/lib/jenkins/credentials.xml/ to backup routine
* xmlstarlet -> create a definition for pretty_print to allow for reuse.
* Move httpd header augeas type definition into the augeas class
* extend augeas definition to allow for pretty print

### Notes