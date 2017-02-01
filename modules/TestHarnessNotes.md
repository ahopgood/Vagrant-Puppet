# Test Harness Notes
## Requirements
All tests need to be puppet manifests located in the `/modules/<module_name>/tests/` directory, there can be **no other** file types.  
A Vagrantfile needs to be present in `/modules/<module_name>/`.  
This Vagrant file needs to specify a `config.vm.define "<name>"` section with a name of the format **<OS_NAME>_<MAJOR_VERSION>_test** e.g.:  

* CentOS_6_test
* Ubuntu_15_test

There must not be a newly generated ssh key added to the build as this will prevent login so add the following `CentOS_6_test.ssh.insert_key = false`.
The box used must support puppet e.g. `CentOS_6_test.vm.box = "puppetlabs/centos-6.6-64-puppet"` 

## Current Support
* CentOS6 
* Tomcat module only
* tomcat6 test manifest with Java version 6u45
* tomcat7 test manifest with Java version 7u11
* Works sequentially on a single core, even if there are multiple VMs it will only go through one at a time, might change this in future

## Snapshots, why use them?
Running two faulty (in different ways) test manifests using snapshots resulted in the following running time:
```
Test results:
tomcat6.pp result [1] tomcat7.pp result [1]

real    1m48.699s
user    0m15.180s
sys     0m4.540s
```
Replacing the snapshotting with creation and destruction of the instance for each manifest resulted in the following running time:
```
Test results:
tomcat6.pp result [1] tomcat7.pp result [1]

real    1m50.096s
user    0m14.324s
sys     0m4.080s

```

## To Do
* Perform correct argument checking for each part / function of the test_harness.sh
* Create a permissive hierarchy of args that fall back to defaults:
    * If a module name isn't provided then use the directory listing
    * if a VM name isn't provided then use the vagrant status listing
    * if a manifest isn't provided then use the directory listing
* Add help file for providing useful feedback to standard out
    * Abbreviated args list if args are missing
    * Verbose help if the `--help` args are used
* option for verbose output
* option for version information? (-v?)
* Rename the output files after generation to append the error code at the end.
* Removal of *test-errors.txt files if they are empty or if they have a zero error code.
* Addition of `--detailed-exitcodes` to puppet apply with `--noop` to hopefully return the correct error codes, or actually apply puppet and see what happens.
* Split each function into a separate script file.
* Possibly rewrite in ruby to increase portability of results.
* Change the output file names to be in the order of <vm_name>-<manifest_name>_test_errors.txt.
* Reformat the output array to provide a justified error code that is coloured based on its zero or non-zero status
