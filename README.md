Vagrant-Puppet
==============

A test project for experimenting with vagrant and puppet

The **modules** folders contain puppet scripts, resources and templates specific and restricted to certain functionality. For example the installation, configuration and starting of tomcat as a service and be found in the *tomcat* module folder.

## Branching Strategy
The `master` branch is to be used for all production code.  
It is to be a source of single truth, only tested modules with sufficiently detailed readme.md files should be present.  

All **feature** work is to be done on git branches.  
The naming of the branches should adhere to the following pattern:  
`modulename`/`featurename` an example would be **alternatives/remove** for the removal feature of the alternatives module.  

A feature can be merged back to master via a **pull request** once it meets the following conditions:
* It has been tested.
* These tests have been written up in the readme.
* The readme has been updated with design decisions taken and the platforms the module is known to be tested with.
* The readme has any known issues listed.
* The readme contains a list of `todos` detailing what else can / should be done in future  