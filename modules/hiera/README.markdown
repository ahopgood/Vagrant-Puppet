# hiera #

This is the hiera module. It provides...

## Usage
Currently the module needs to be run twice when being used by another module to extract
 values:
1. The first run is to ensure the `hiera.yaml` configuration file and `hieradata/common.yaml` files are setup in the puppet home directory: `/etc/puppet/`
2. The second run is when the manifest will be able to pull value from hiera
`puppet apply --hiera-config=/etc/puppet/hiera.yaml` with our specified hiera.yaml configuration file.

```
sudo puppet apply /vagrant/tests/eyaml.pp --modulepath=/etc/puppet/modules/
```

```
class{"hiera::eyaml":
  private_key_file => "private_key.pkcs7.pem",
  public_key_file => "public_key.pkcs7.pem",
}
```
Parameters available are:
* `private_key_file` (no default) the name of the private pkcs7 pem file for decoding eyaml contents
* `public_key_file` (no default) the name of the public pkcs7 pem file for encoding eyaml contents
* `hiera_conf` (default value "hiera.yaml") the name of the hiera configuration file in your puppet home directory
* `puppet_home` (default value "/etc/puppet/") the directory where your puppet installation sources its modules and configuration from.
* `hiera_data` (default value "/etc/puppet/hieradata/") the location of the hiera data directory, 
this is the location that matches the one found in the hiera configuration file for the `datadir`  
* `eyaml_keys` (default value "/etc/puppet/hieradata/keys/") the directory containing the public and private eyaml keys specified above

### Command line
Encrypt values `eyaml encrypt`
Decrypt values `eyaml decrypt`
Parameters:
* `--pkcs7-private-key=<private_key_path>`
* `--pkcs7-public-key=<public_key_path>`
* `-s <string-value>` or `--string=<string-value>` to encrypt/decrypt a string value
* `-f <file-name>` or `--file=<file-name>` to encrypt/decrypt from a file
* `-e <eyaml-file-name>` or `--eyaml=<eyaml-file-name>` to encrypt/decrypt from an eyaml file

### Gem installation
`sudo gem install hiera-eyaml`

## Todo
* Add eyaml support
    * example vagrant file with directory mapping for the keys directory
    * dependency on the hiera class
    * updating of the hiera.yaml file to add the eyaml backend
    * specification of the key locations
    * specification on where the hiera data is, allow for default to be the same as hiera with an override option
    * specification of the extension to use: eyaml or yaml.