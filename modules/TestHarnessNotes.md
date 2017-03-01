# Test Harness Notes
This test harness is designed to run test manifests for puppet modules against vagrant virtual machines to provide feedback after manifest changes.  
Without any parameters the script will iterate through the current `modules` directory, enter the `<module_name>` directory and perform a `vagrant status` to find specific test VMs.  
It will then run all test manifests found in the `<module_name>/tests` directory against each VM found by the vagrant status command.   
For each VM it will create a snapshot and run the test manifest before restoring the snapshot and moving onto the next test.  

## Usage
* `bash test_harness.sh` will run against **all modules** with **all OS profiles** and using **all test manifests**
* `bash test_harness.sh [-m module_name]` will run against the specified **named modules** with **all OS profiles** and using **all test manifests**
* `bash test_harness.sh [-p os_profile]` will run against **all modules** with the specified **named OS profiles** and using **all test manifests**
* `bash test_harness.sh [-t test_manifest]` will run against **all modules** with **all OS profiles** and using the specified **named test manifests**

Note that a *single* module, os profile or test manifest can be defined without quotes. *Multiple* modules, os profiles or test manifests will need to use quotes e.g.:
`[bash test_harness.sh -m "module1 module2"` it is **not** recommended to have spaces in your module directory, os profile or test manifest names.

## Current Support
* Works sequentially on a single core, even if there are multiple VMs it will only go through one at a time, might change this in future
* Needs to be run from within the root of the `/modules` folder.

## Requirements
All tests need to be puppet manifests located in the `/modules/<module_name>/tests/` directory, there can be **no other** file types.  
A Vagrantfile needs to be present in `/modules/<module_name>/`.  
This Vagrant file needs to specify a `config.vm.define "<name>"` section with a name of the format **<OS_NAME>_<MAJOR_VERSION>_test** e.g.:  

* CentOS_6_test
* Ubuntu_15_test

There must not be a newly generated ssh key added to the build as this will prevent login so add the following `CentOS_6_test.ssh.insert_key = false`.
The box used must support puppet e.g. `CentOS_6_test.vm.box = "puppetlabs/centos-6.6-64-puppet"`

## Snapshots, why use them?

## To Do
* **done** Rename the output files after generation to append the error code at the end.
* **done** Removal of *test-errors.txt files if they are empty or if they have a zero error code.
* **done** Create a permissive hierarchy of args that fall back to defaults:
    * **done** If a module name isn't provided then use the directory listing
    * **done** If a VM name isn't provided then use the vagrant status listing
    * **done** If a manifest isn't provided then use the directory listing
* Add help file for providing useful feedback to standard out
    * **done** Abbreviated args list if args are missing
    * Verbose help if the `--help` args are used
* Perform correct argument checking for each part / function of the test_harness.sh
* option for verbose output
* option for version information? (-v?)
* Split each function into a separate script file.
* Possibly rewrite in ruby to increase portability of results.
* Change the output file names to be in the order of <vm_name>-<manifest_name>_test_errors.txt.
* Reformat the output array to provide a justified error code that is coloured based on its zero or non-zero status
* Support for spaces in module, os profile and test manifest names