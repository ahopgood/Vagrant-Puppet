# alternatives #

This is the alternatives module. It provides...

Two main definitions:  
* `alternatives::install`
* `alternatives::set`

## Conditions of use
### Puppet prior to 4.0.0
When flattening down entries in the `$slaveHash` parameter into a single command line string the puppet parser needs to use the **future parser**.
`puppet apply manifestname.pp --parser=future`  
If this isn't used then the catalogue/manifest won't compile.

Currently there is support for the following operating systems:  
* **Ubuntu** via the `update-alternatives` binary
	* 15.10 tested
* **CentOS** via the `alternatives` binary
	* 6 tested
	* 7 tested