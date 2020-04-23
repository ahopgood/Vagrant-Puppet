# Vagrant Module

This module will attempt to secure vagrant from its not so safe default settings.  
This will replace the public key with a new one that is paired to another private key that isn't the default.  
The default `vagrant` password is reset.  
It will revoke the sudo privileges of the `vagrant` user.  
  
## Support
* Ubuntu 15.10
* Ubuntu 16.04

## Usage
```
vagrant {
    "somename":
    public_key => "",
    password => ""
}
```

* `public_key` the character escaped public key contents 
* `password` the character escaped password hash 

## Parameter notes
The `public_key` and `password` parameter strings will need the dollar signs escaped, e.g. `$6$CmPxLmdO` will become `\$6\$CmPxLmdO`.  
Both the `public_key` and `password` have defaults that are **not** the vagrant defaults so it can just be called like so:  
```
vagrant {
    "somename":
}
```
It is recommended that you change from these defaults too.  