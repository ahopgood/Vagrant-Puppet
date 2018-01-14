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

### Ubuntu
Back up and restore functionality is provided by a series of local scripts:
* `/usr/local/bin/retrieve-all-plugins.sh` will parse the `plugins.txt` from a backup location and loop through each line trying to restore a plugin.
* `/usr/local/bin/retrieve-plugin.sh` is used to restore a single plugin:version:hash string value, this will check for a local version with a matching hash first and then resort to the plugin centre. If no version is provided it will pull the latest version of the plugin by default.
* `/usr/local/bin/backup-plugins.sh` is present in both manual and automatic install (in case the of the need for a manual backup) and will trigger every five minutes via cron on the manual install.

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

## ToDo
### CentOS
### Ubuntu
* Create a credentials.xml file for adding our github token. Need to provide a credentials version from our plugin file
* Create a directory for the seed job in the jobs folder where the folder name is the job name
* Create a builds folder within the job folder
* Create a config.xml file
*
* Add /files/var/lib/jenkins/credentials.xml/ to backup routine
*