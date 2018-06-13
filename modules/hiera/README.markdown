# hiera #

This is the hiera module. It provides...

## Usage
Currently the module needs to be run twice when being used by another module to extract values:
1. The first run is to ensure the `hiera.yaml` configuration file and `hieradata/common.yaml` files are setup in the puppet home directory: `/etc/puppet/`
2. The second run is when the manifest will be able to pull value from hiera
`puppet apply --hiera-config=/etc/puppet/hiera.yaml` which our specified hiera.yaml configuration file.  

### Command line
`eyaml encrypt `

## Todo
* Add eyaml support
    * gem installation
    * key directory creation and permissions
    * key permissions
    * example vagrant file with directory mapping for the keys directory
    * dependency on the hiera class
    * updating of the hiera.yaml file to add the eyaml backend
    * specification of the key locations
    * specification on where the hiera data is, allow for default to be the same as hiera with an override option
    * specification of the extension to use: eyaml or yaml.