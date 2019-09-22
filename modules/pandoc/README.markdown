# Pandoc

This is the Pandoc module. It provides...
Pandoc with some support for extra modules:
* texlive-fonts-recommended
* texlive-latex-extra
* lmodern
## Current Status / Support

Supports:
* Ubuntu 15.10
* Ubuntu 16.04

### Known Issues  
**64-bit support only**  
[CentOS Known Issues](#CentOS_known_issues)  
[Ubuntu Known Issues](#Ubuntu_known_issues)  

## Usage 
```
class{"pandoc":
}
->
pandoc::texlive_fonts_recommended{"texlive_fonts_recommended":}
->
pandoc::texlive_latex_extra{"texlive_latex_extra":}
->
pandoc::lmodern{"lmodern":}
```
## Testing performed:
* Install on a fresh system
	* Ubuntu 15.10
	* Ubuntu 16.04
	
## Ubuntu
### <a name="Ubuntu_known_issues">Ubuntu known issues</a>

### <a namme="Debian_file_naming_conventions">Debian File naming conventions</a>
The *.deb* package installer files can be found under a OS-Version specific directory tree: `files/OS/Version`:
* `files/Ubuntu/15.10/`
* `files/Ubuntu/16.04/`

### Adding compatibility for other Ubuntu versions
Add a vagrant base box profile for your new Ubuntu version.  
Create a new version under the `files/Ubuntu/` directory for the new version of Ubuntu you are installing.   
Create a new puppet manifest named after the distro, e.g. `bionic`, `xenial` etc with the correct namespace; `pandoc::ubuntu::bionic`, `pandoc::ubuntu::xenial` etc.  
In the main `init.pp` declarations add a new version check and delegate to your new puppet manifest:  
```
  } elsif (versioncmp("${operatingsystemmajrelease}", "16.04") == 0) {
    pandoc::ubuntu::xenial::lmodern{"xenial dependencies":}
  } elsif (versioncmp("${operatingsystemmajrelease}", "18.04") == 0) { 
    pandoc::ubuntu::bionic::lmodern{"bionic dependencies":}
  } else {
    fail("${operatingsystemmajrelease} is not supported")
  }

```

## ToDo
### Ubuntu
Move all **wily** (Ubuntu 15.10) code into their own manifests just like the xenial stuff.  
