# httpd / Apache2
This is the httpd module. It provides... [httpd / Apache2 functionality](https://httpd.apache.org/)

The module can be passed the following parameters as Strings:  
* Major version number, e.g. "2"
* Minor version number, e.g. "4"
* Patch version number e.g. "12"

Supplementary Documentation:
* [Virtual Hosts](#VirtualHosts)
* [Terry Pratchett x-clacks header](#Terry_Pratchett_x-clacks_header)
* [Content Security Policy header](#Content_Security_Policy_header)
* [X-Content-Type-Options header](#x-content-type-options)
* [X-Frame-Options header](#x-frame-options)
* [X-Xss-Protection header](#x-xss-protection)
  
## Current Status / Support
Tested to work on the following operating systems:
* CentOS 6 - Apache 2.2.15, **it is advisable to move on from CentOS 6 - these repositories are no longer being updated**
* CentOS 7 - Apache 2.4.6
* Ubuntu 15.10 - Apache 2.4.12 **it is advisable to move on from Ubuntu 15.10 - these repositories are no longer being updated**
* Ubuntu 16.04 - Apache 2.4.39
* Ubuntu 18.04 - Apache 2.4.39

### Known Issues  
* **64-bit support only**  
* [CentOS Known Issues](#CentOS_known_issues)  
* [Ubuntu Known Issues](#Ubuntu_known_issues)  

## Usage 
Can be declared via the *httpd* class:
```	
class{"httpd":}
```
or directly via the *httpd::ubuntu* class:
```
service ufw::service{"ufw-service":}
    
class {"httpd::ubuntu":
  major_version => "2",
  minor_version => "4",
  patch_version => "12",
}
```
or directly via the *httpd::centos* class:
```	
class{httpd::centos":
  httpd_user => "httpd", 
  httpd_group => "httpd",
}
```

### Puppet Command
```
sudo puppet apply --parser=future --modulepath=/etc/puppet/modules /vagrant/tests/virtual_host_httpd.pp

```
## Dependencies
### CentOS
* iptables module is required [raw readme here](../iptables/README.markdown)
* Port exception added for `port 80` to ensure http traffic can get through to the HTTP server
### Ubuntu
* `ufw` module is required [raw readme here](../ufw/README.markdown)
* Need to declare the ufw `service ufw::service{"ufw-service":}` somewhere in your manifest
* Port exception added for `port 80` to ensure http traffic can get through to the HTTP server

## Testing performed:
* Install on a fresh system
	* CentOS6
	* CentOS7
	* Ubuntu 15.10 - Apache 2.4.12
	* Ubuntu 16.04 - Apache 2.4.39
## CentOS
Installs apache to the following locations:
* `/usr/sbin/httpd` executable file
* `/var/log/httpd/` logging directory
* `/etc/httpd/` main application directory
* `/etc/httpd/conf/` configuration directory
* `/etc/httpd/conf/httpd.conf` main configuration file for apache web server 
* `/var/www/html/` default document root for serving web pages

### CentOS6
Command line service calls are as follows:  
* `sudo /etc/init.d/httpd start` to start the service
* `sudo /etc/init.d/httpd stop` to stop the service
* `sudo /etc/init.d/httpd restart` to restart the service
* `sudo /etc/init.d/httpd status` to get the current status of the service

### CentOS7
Command line service calls are as follows:
* `sudo systemctl start httpd` to start the service
* `sudo systemctl stop httpd` to stop the service
* `sudo systemctl restart httpd` to restart the service
* `sudo systemctl status httpd` to get the current status of the service

### Known issues <a name="CentOS_known_issues"></a>
* CentOS 6 is on a very out of date version of apache (2.2.15), the repositories for this version of CentOS are no longer being updated.

### CentOS file naming conventions <a name="CentOS_file_naming_conventions"></a>
The *.rpm* files with the appropriate minor-major numbers need to be located in the **files/CentOS/6** folder for the passed parameters to allow for installation of the correct apache httpd version.  
Ensuring this pattern is followed will allow the module to locate files correctly, it was decided not to rename all the rpms into a common naming structure since this places the onus on the person running the module to rename files every time there is an update.  

This decision may be revisited in future in order to simplify the module if the Apache foundation continue to change their naming scheme.  
### Adding compatibility for other CentOS versions
Ensure that a new directory is present in the /file/CentOS/* directory named after the new version of CentOS and ensure the apache installer is present.    
For the **existing** dependencies if they are still applicable then you need to add them to the new version directory.   
You will also need to add these new file names/versions to the main **centos.pp** manifest and include a new condition to resolve for your version of the OS.  
```
	$apr_file = $os ? {
    	'CentOS7' => "apr-1.4.8-3.el7.x86_64.rpm",
    	'CentOS6' => "apr-1.3.9-5.el6_2.x86_64.rpm",
    	default => undef,
	}
```
For the apr library cecomes the following for CentOS 8:  
```
	$apr_file = $os ? {
    	'CentOS7' => "apr-1.4.8-3.el7.x86_64.rpm",
    	'CentOS6' => "apr-1.3.9-5.el6_2.x86_64.rpm",
		'CentOS8 => "apr-1.5.1-2-el8.x86_64.rpm",
    	default => undef,
	}
```
If there are **new** dependencies then you'll need to add their installers to the **/files/CentOS/x/** folder where x is the CentOS version and you'll need to create a whole new conditional resolution for the library name, similar to the **apr** example above to ensure that name resolves correctly.  
As well as name resolution you'll also need to add a conditional section based on the OS version to actually obtain the installer file and then install the package, an example for the apr installer is found below:  
```
	file{
    	"${local_install_dir}${apr_file}":
    	ensure => present,
    	path => "${local_install_dir}${apr_file}",
    	source => ["puppet:///${puppet_file_dir}${apr_file}"]
	}
	package {"apr":
    	ensure => present,
    	provider => 'rpm',
    	source => "${local_install_dir}${apr_file}",
    	require => File["${local_install_dir}${apr_file}"]
	}
```
All dependencies and the actual Apache installer itself are best obtained by running `yumdownloader <installername>` on the target CentOS version, sometimes this will require `sudo apt-get install yum-utils` to be installed first.  

### Adding new major versions of Apache
Ensure that the .rpm installer is present in the */file/CentOS/* directory under the correct version of CentOS.  
The installer will need to follow the same naming conventions as found in [CentOS file naming conventions](CentOS_file_naming_conventions) section.  
If the dependencies change between versions then a new conditional section will need to be added to include these dependencies for your specific version of Apache.  

## Ubuntu
Installs apache to the following locations:
* `/usr/sbin/apache2` executable file
* `/var/log/apache2/` logging directory
* `/etc/apache2/` main application & configuration directory
* `/etc/apache2/apache2.conf` main configuration file for apache web server 
* `/var/www/html/` default document root for serving web pages

Command line service calls are as follows:  
* `sudo service apache2 start` to start the service
* `sudo service apache2 stop` to stop the service
* `sudo service apache2 restart` to restart the service
* `sudo service apache2 status` to get the current status of the service

### Ubuntu known issues<a name="Ubuntu_known_issues"></a>
* iptables isn't supported by default on Ubuntu 15.10 - modular dependency between httpd and iptables will cause module to fail.
* Ubuntu support is still under development

### Debian File naming conventions <a name="Debian_file_naming_conventions"></a>
The *.deb* files with the appropriate minor-major numbers need to be located in the **files/Ubuntu/15.10** folder for the passed parameters to allow for installation of the correct apache2 version.  
<!--
The naming of these *.deb* files should follow the following convention in order for the correct version to be selected:  
**apache2_&ltmajor_version$gt%2E&ltminor_version$gt%2E&ltpatch_version$gt-Ubuntu_&ltubuntu_version$gt_amd64.deb**  
an example would be:  
`apache2_2.4.12-Ubuntu_15.10_amd64.deb`
-->
### Adding compatibility for other Ubuntu versions
Ensure that a new directory is present in the /file/Ubuntu/* directory named after the new version of Ubuntu and ensure the apache installer is present.    
For the **existing** dependencies if they are still applicable then you need to add them to the new version directory.   
You will also need to add these new file names/versions to the main **ubuntu.pp** manifest and include a new condition to resolve for your version of the OS.  
```
	$apr_file = $os ? {
    	'Ubuntu15.10' => "libapr1_1.5.2-3_amd64.deb",
    	'Ubuntu16.04' => "libapr1_1.6.2-1+ubuntu16.04.1+deb.sury.org+2_amd64.deb",
    	default => undef,
	}
```
If there are **new** dependencies then you'll need to add their installers to the **/files/Ubuntu/x/** folder where x is the CentOS version and you'll need to create a whole new conditional resolution for the library name, similar to the **apr** example above to ensure that name resolves correctly.  
As well as name resolution you'll also need to add a conditional section based on the OS version to actually obtain the installer file and then install the package, an example for the apr installer is found below:  
```
	file{
    	"${local_install_dir}${apr_file}":
    	ensure => present,
    	path => "${local_install_dir}${apr_file}",
    	source => ["puppet:///${puppet_file_dir}${apr_file}"]
	}
	package {"apr":
    	ensure => present,
    	provider => 'rpm',
    	source => "${local_install_dir}${apr_file}",
    	require => File["${local_install_dir}${apr_file}"]
	}
```
All dependencies and the actual Apache installer itself are best obtained by running `apt-get download <installername>` on the target Ubuntu version.  

### Adding new major versions of Apache
To get the latest version of apache2 from Ubuntu's default repositories use `apt-get update && apt-get download apache2`.  
If you need the latest version of apache2 and it **isn't available** via the default repositories then you'll need to add a third party repository:
```bash
  sudo add-apt-repository ppa:ondrej/apache2
  sudo apt-get update

```
## Terry Pratchett x-clacks header <a name="Terry_Pratchett_x-clacks_header"></a>
Support has been added for the following HTTP header:
`X-Clacks-Overhead "GNU Terry Pratchett"`
An explanation can be found [here](http://www.gnuterrypratchett.com/).
### Usage
```puppet
  $virtual_host="foo.bar.com"
  class { "httpd": }
  ->
  httpd::headers::xclacks{"${$virtual_host}":}
```
This will add a directive on the `/var/www/html` directory.
The directive looks like this on Ubuntu:
```
<Directory "/var/www/html/">
<IfModule headers_module>
header set X-Clacks-Overhead "GNU Terry Pratchett"
</IfModule>
</Directory>
```
And this on CentOS:
```
<IfModule mod_headers.c>
<Directory "/var/www/html/">
header set X-Clacks-Overhead "GNU Terry Pratchett"
</Directory>
</IfModule>
```

To add to a virtual host you do the following:  
```
  class { "httpd": }
  ->
  httpd::xclacks{"x-clacks":
    virtual_host => "www.alexander.com"
  }
```
This will add the x-clacks header to the conf file for the virtual host.
On Ubuntu this looks like the following in `/etc/apache2/sites-enabled/www.alexander.com.conf`:
```
<VirtualHost *:80>
....
<IfModule headers_module>
header set X-Clacks-Overhead "GNU Terry Pratchett"
</IfModule>
</VirtualHost>
```
And like this on CentOS (7 in `/etc/httpd/sites-enabled/www.alexander.com.conf` and 6 in `/etc/httpd/conf/conf.d`

### Dependencies
This will only work if the headers module is installed on apache which is done by the `httpd::header::install` module.
This module requires virtual host sites support if it is to be set on a VirtualHost:
`class {"httpd::virtual_host::sites":}`

## Content Security Policy header <a name="Content_Security_Policy_header"></a>
An apache/httpd implementation of a [Content Security Policy](https://content-security-policy.com/) header.
I had to roll my own augeas header solution due to conflicts with string escaping on puppet and augeas conspiring to prevent me using strings such as "default-src 'self';".

### Usage
When using the CSP module the `--parser=future` parameter is required on puppet 3.7.x up to 4.0.0 to make use of some of the more advanced parser features to manipulate parameters.
```puppet
$virtual_host="foo.bar.com"
httpd::headers::content_security_policy{"${virtual_host}":
	virtual_host => "${virtual_host}",
	csp_rule => "\"\\\"default-src \'none'\'\\\"\""
}
```
The above usage will set the following header on the `foo.bar.com` virtual host:  
```
<VirtualHost *:80>
    DocumentRoot /var/www/foo/bar/
    ServerName www.foo.bar.com
    ...
    <IfModule headers_module>
        ...
        header set Content-Security-Policy "default-src 'none''"
    </IfModule>
</VirtualHost>
```

There are a huge number of possible CSP values/rules you can configure see []() for a good write up.  

#### Notes on CSP rules
A csp rule takes the form of a series of semi-colon separated entries encapsulated within double quotation marks ("something").  
Each entry contains a prefix to indicate what type of content it applies to. 
This is followed by a space separated list of domains it can be loaded from and / or the entries 'self' to indicate loading from the same origin or 'none' to indicate no restrictions (note the single quotation marks 'something').  
 
There is a slightly annoying amount of string escaping required on the single and double quotations to reach our desired CSP rule.  
String escaping on the puppet level is required to pass the quotation marks to Augeas.  
Further string escaping is required to allow Augeas to interpret the quotation marks as actual quotation marks.  
Below is a series of examples:
##### Desired rule
```
"script-src 'self' mydomain.com; style-src 'none';"
```
##### String required by Augeas 
In Augeas the double quotes need to be escaped so they aren't interpreted as terminating string characters.
```
\"script-src 'self' mydomain.com; style-src 'none';\"
```
##### String required by Puppet  
We need to add Puppet escaping to allow `\"` to pass to augeas, so this becomes `\\\"`.
```
\\\"script-src 'self' mydomain.com; style-src 'none';\\\"
```
In Puppet the single quotes also need to be escaped:
```
\\\"script-src \'self\' mydomain.com; style-src \'none\';\\\"
```
Augeas also needs the entire thing wrapped in double quotes so it can interpret it as a string expression internally so we add another set of escaped quotes around it: 
```
\"\\\"script-src \'self\' mydomain.com; style-src \'none\';\\\"\"
```
And finally as this is a puppet string itself the whole lot is encapsulated again in double quotes:
```
"\"\\\"script-src \'self\' mydomain.com; style-src \'none\';\\\"\""
```

### Defaults
If **no** `virtual_host` parameter is set then the header is assumed to be set to a `global` scope.  
The default value of `"default-src 'none'"` is used for the Content-Security-Policy value, being secure by default unless overridden by a more specific rule.   

### Dependencies
This will only work if the headers `httpd::header::install`  module is installed .
The Augeas class is required.  
**Note** Use of the x-clacks-overhead *after* this module call will overwrite your **global** CSP header currently, virtual host policies will not be impacted.
It is advisable to run the x-clacks first and then CSP as the CSP module has finer grained onlyif statements for detecting duplication, existing and/or modified values.
```
  httpd::xclacks{"x-clacks":}
  httpd::content_security_policy{"CSP": }
```

<a name="x-content-type-options"></a>
## X-Content-Type-Options header
This definition will set the [X-Content-Type-Options](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options) header.  
   
### Usage
```puppet
$virtual_host="foo.bar.com"
httpd::headers::x_content_type_options{"${virtual_host}":
	virtual_host => "${virtual_host}",
	header_value => "nosniff"
}
```
The above usage will set the following header on the `foo.bar.com` virtual host:  
```
<VirtualHost *:80>
    DocumentRoot /var/www/foo/bar/
    ServerName www.foo.bar.com
    ...
    <IfModule headers_module>
        ...
        header set X-Content-Type-Options nosniff
    </IfModule>
</VirtualHost>
```

Possible values for the header are:
* `nosniff` - will block any `script` or `style` resource request that does not have the correct MIME type of `text/css` for style or the [JavaScript MIME types](https://mimesniff.spec.whatwg.org/#javascript-mime-type)

### Defaults
If **no** `virtual_host` parameter is set then the header is assumed to be set to a `global` scope.  
The default value of `nosniff` is used for the X-Content-Type-Options value to ensure correct MIME types are used.     

### Dependencies
This will only work if the headers module is installed on apache which is done by the `httpd::header::install` module.
This module requires virtual host sites support if the header is to be set on a VirtualHost:
`class {"httpd::virtual_host::sites":}`

<a name="x-frame-options"></a>
## X-Frame-Options header
This definition will set the [X-Frame-Options](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options) header.
This header is used to prevent [clickjacking](https://en.wikipedia.org/wiki/Clickjacking) attempts by indicating if a browser is allowed to render a page in an <frame>, <iframe>, <embed> or <object>.
### Usage
```puppet
$virtual_host="foo.bar.com"
httpd::headers::x_frame_options{"${virtual_host}":
	virtual_host => "${virtual_host}"
}
```
The above usage will set the following header on the `foo.bar.com` virtual host:  
```
<VirtualHost *:80>
    DocumentRoot /var/www/foo/bar/
    ServerName www.foo.bar.com
    ...
    <IfModule headers_module>
        ...
        header set X-Frame-Options deny
    </IfModule>
</VirtualHost>
```

Possible values for the header are:
* `deny` - the page is not allowed to be rendered in a frame, regardless of origin
* `sameorigin` - the page can **only** be rendered in a frame if it has the **same origin** as the page itself 
* `allow-from <origin_uri>` the page can be rendered within a frame provided the request comes from a specified origin e.g. allow-from https://example.com/ 

### Defaults
If **no** `virtual_host` parameter is set then the header is assumed to be set to a `global` scope.  
The default value of `deny` is used for the X-Frame-Options value to ensure no click jacking can occur out of the box, if you want to relax these settings you need to knowingly do so.  
   
### Dependencies
This will only work if the headers module is installed on apache which is done by the `httpd::header::install` module.
This module requires virtual host sites support if the header is to be set on a VirtualHost:
`class {"httpd::virtual_host::sites":}`

<a name="x-xss-protection"></a>
## X-XSS-Protection header
This definition will set the [X-XSS-Protection](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection) header.  
This informs older browsers how the site wants Cross Site Scripting (XSS) protections to be enforced (if any).  
This header is superseeded by the [Content-Security-Policy](#Content_Security_Policy_header) header in newer browsers.  

### Usage
```puppet
$virtual_host="foo.bar.com"
httpd::headers::x_xss_protection{"${virtual_host}":
	virtual_host => "${virtual_host}",
	header_value => "1"
}

```
The above usage will set the following header on the `foo.bar.com` virtual host:  
```
<VirtualHost *:80>
    DocumentRoot /var/www/foo/bar/
    ServerName www.foo.bar.com
    ...
    <IfModule headers_module>
        ...
        header set X-XSS-Protection 1;
    </IfModule>
</VirtualHost>
```

Possible values for the header are:
* `0` - **disables** XSS filtering
* `1` - **enables** XSS filtering, the browser will sanitise any parts of the page used in a cross-site scripting attack.
* `1; mode=block` - **enables** XSS filtering and **blocks** rendering of the page if an attack is detected. 
* `1; report=<reporting-uri>` - **enables**  XSS filtering, sanitises the page and reports the violation to the specified URI.  

### Defaults
If **no** `virtual_host` parameter is set then the header is assumed to be set to a `global` scope.  
The default value of `1; mode=block` is used for the X-XSS-Protection value so you will know that a Cross Site Scripting has occurred as your page will fail to load.   

### Dependencies
This will only work if the headers module is installed on apache which is done by the `httpd::header::install` module.
This module requires virtual host sites support if the header is to be set on a VirtualHost:
`class {"httpd::virtual_host::sites":}`

### ToDo
* Move testfile.txt into a variable
* Delete testfile.txt as part of the module tidyup
* Add an onlyif clause to the augeas executable
  * Externalise the equality condition as a variable 
  * Externalise the size condition as a variable matched to grep -c and awk
* Extract augeas bits into a separate define section?
* Move the restarting of apache sections into their own definition
* Have x-clacks use the httpd::restart definition
* Replace CSP restarts with httpd::restart
* Combine the virtualhost CSP section into one place
* Update readme section with actual config file entries for apache2 and httpd for virtualhost
* See if we can add the:
```
        "save",
        "print /augeas//error"
```
call to the header module header_contents array.

## Virtual Hosts <a name="VirtualHosts"></a>
Required parameters:  
* `server_name` - the domain name of the server you want a virtual host for e.g. www.google.co.uk, this will be used to match incoming requests and also to name the virtual host configuration file.
* `document_root` - the location of the web resources you will be serving via your virtual host

Optional parameters:  
* `server_alias` - an array of strings that represent the server aliases
* `access_logs` - a boolean, indicates if you wish the virtual host to have its own access logs in `/var/logs/apache2/`, defaults to **false**
* `error_logs` - a boolean, indicates if you wish the virtual host to have its own error logs in `/var/logs/apache2/`, defaults to **false**

This definition allows for you to setup a virtual host linked to a domain (server_name) of your choice to web assets (document_root) hosted on your server.
The document root / web page assets are not instantiated through this definition, you create those elsewhere however you want.
A list of server aliases can be used to setup separate `ServerAlias` entries in the configuration file for a site.
Error and access logs if enabled will be named after the virtualhost name with either `-access.log` or `-error.log` appended. 
Custom error and access logs will be removed if set to false.  
### Usage
```
class {"httpd::virtual_host::sites":}
httpd::virtual_host{"www.cv.alexanderhopgood.com":
  server_name   => "www.cv.alexanderhopgood.com",
  document_root => "/var/www/alexander/cv/",
  server_alias => ["cv.alexanderhopgood.net","cv.alexanderhopgood.co.uk","cv.alexanderhopgood.com"],
}
```
### Dependencies
* Requires sites directories (`sites-enabled` and `sites-available`) to be present on apache 2.4+, provided by the `httpd::virtual_host::sites` class

### Support
* CentOS 7
* CentOS 6
* Ubuntu 15.10

### ToDo
* Add support for error log
* Add support for custom log
* SSL support

## Proxy Gateway <a name="Gateway"></a>
This definition allows setup of apache as a gateway by installing the `proxy` and `proxy_httpd` modules
### Usage
```
httpd::proxy::gateway::install{"":}
```
### Dependencies
* Requires the `module` module provided by the `httpd::module::install` definition which is used to install the `proxy` and `proxy_httpd` modules.

### Support
* Ubuntu 15.10

#### Virtual Hosts
A VirtualHost can be configured to be a gateway to another machines
Required parameters:
* `virtual_host` - the name of the virtual host, this is the `server_name` used when configuring the [VirtualHost](#VirtualHosts) module, this name is used to derive the VirtualHost configuration file.  
* `host_address` - the host IP address (and port if required) that the gateway will forward traffic to from the VirtualHost.  
* `require_origin_address` (Optional) - will restrict the gateway to only service requests come from a specific IP address or [CIDR](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing) representation subnet.
#### Usage
```
  httpd::proxy::gateway::set_virtual{"":
    virtual_host => undef,
    host_address => undef,
    required_origin_address => undef }
```
### ToDo
* Try to use this as an `@httpd::proxy::gateway::install` realized resource.
* Wire up virtual_host parameter to augeas definition
* Wire up host_address parameter to augeas definition
* Wire up require_origin_address parameter to augeas definition
* Split augeas steps to make require_origin_address optional
* Add onlyif clause to main virtual_host and host_address sections to ensure they update correctly



## ToDo
* Increase supported Apache versions from the current least supported version of this module to the most current version released in the OS's repository:  
	* CentOS6 current - 2.2.15 this is the latest in the CentOS6
	* CentOS7 - 2.4.6  
	* Ubuntu - 2.4.12
* **done** Ubuntu support
* **done** Virtual Host configuration
* Raspberian support
* SSL Configuration
* Custom error pages; 404, 401, 403, 500 etc
* Removal of Operating System information from error pages 
* Removal of apache version information from error pages
* Have all files saved to `/etc/puppet/installers/httpd/`
* In the case of an upgrade from one version of apache to another, remove old package files from `/etc/puppet/installers/httpd` folder
* Proxy pass
* **done** VirtualHost error log
* **done** VirtualHost custom log
