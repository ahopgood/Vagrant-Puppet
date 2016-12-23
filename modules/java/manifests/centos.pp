Package{
  allow_virtual => false,
}
define java::centos(
  $version = "6",
  $updateVersion = "45",
  $is64bit = true,
  $multiTenancy = false,
  ){
    $local_install_path = "/etc/puppet/"
    $local_install_dir  = "${local_install_path}${name}/"
    $puppet_file_dir    = "modules/java/"
    
    file {
      "${local_install_dir}":
      path       =>  "${local_install_dir}",
      ensure     =>  directory,
    }
  
    #Derive rpm file from verion number, update number and platform type
    if ($is64bit == true){
      if ("${version}" > 6){
        $platform = x64
      } else {
        $platform = amd64
      }
    } else {
      $platform = i586
    }
  
    notify {"Using operating system:$::operatingsystem for Java version ${version}":}
    if ("${version}" == 5){
      $jdk = "jdk-1_${version}_0_${updateVersion}-linux-${platform}.rpm"
    } elsif ("${version}" == 6){
      $jdk = "jdk-${version}u${updateVersion}-linux-${platform}.rpm"
    } else {
      $jdk = "jdk-${version}u${updateVersion}-linux-${platform}.rpm"
    }
    
    #Derive package name from version and update version
    #Java 8 rpm package name is different from previous versions so a straight up upgrade won't happen
    #you'll end up with both versions installed so we need to ensure the previous version is absent
    if ("${version}" == 5 or "${version}" == 6 or "${version}" == 7){
#      $package_name  = "jdk"
      
      $package_name = "jdk-1.${version}.0_${updateVersion}-fcs.x86_64"
    } elsif ("${version}" == 8){
      $package_name  = "jdk1.${version}.0_${updateVersion}-1.${version}.0_${updateVersion}-fcs.x86_64"
    } 
    
    file {
      "${jdk}":
      require    =>  File["${local_install_dir}"],
      path       =>  "${local_install_dir}${jdk}",
      ensure     =>  present,
      source     =>  ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${jdk}"],
    }  
    
    #Will have to switch this to rpm -Uvh as rpm -i won't allow for idempotentcy
    if ("${multiTenancy}" == "true"){
      $install_options = ['--force']
      #Remove old minor versions of this major java package, cannot wildcard as we don't know which major versions we need to keep
      $removeOldJavaPackages = "rpm -e $(rpm -qa | grep jdk*${version}* | grep -v '${package_name}')"
      $checkOldPackagesExist = "rpm -qa | grep jdk*${version}* | grep -v '${package_name}'"
    } else {
      notify{"Multi-tenancy not allowed":}
      #Hack: duplicate notify declaration prevents multiple major versions being installed.
      $install_options = ['--force'] #required for downgrading packages
      #when single tenancy we can use a wildcard match to remove **all** previous versions.
      $removeOldJavaPackages = "rpm -e $(rpm -qa | grep jdk* | grep -v '${package_name}')"
      $checkOldPackagesExist = "rpm -qa | grep jdk* | grep -v '${package_name}'"
    }
    
    package {
      "${package_name}":
      ensure      => "${package_name}",
#      ensure      => installed,
      provider    =>  'rpm',
      source      =>  "${local_install_dir}${jdk}",
      require     =>  File["${jdk}"],
      install_options => $install_options,
    }
    ->
    java::default::install{"install-jdk-${version}-in-alternatives":
      version => $version,
      updateVersion => $updateVersion,
    }
    ->  
    exec {"remove-old-versions-of-java-${version}":
      path => "/bin/",
      command => $removeOldJavaPackages,
      onlyif => $checkOldPackagesExist,
#      command => "rpm -e $(rpm -qa | grep jdk-1.${version}.* | grep -v 'jdk-1.${version}.0_${updateVersion}')",
#      onlyif => "rpm -qa | grep jdk-1.${version} | grep -v 'jdk-1.${version}.0_${updateVersion}'"
    }       
#    if ("${multiTenancy}" == "true"){
#      #Because we used --force on rpm we need to remove the previous minor versions of the major version we're trying to install.
#    }
    #Upgrading Java in a multi-tenancy environment will leave the old versions still installed.
    #i.e. starting with java 6 & 8 then upgrading 6 to 7 will result in 6,7 and 8 being installed
    
    
    #How to uninstall via rpm: rpm -e package name
    #How to query via rpm: rpm -qa | grep 'jdk' 
    #Perhaps we need to clear out any other jdk versions? Perhaps a flag could be set?
    #RPM package names:
    #jdk1.8.0_25-1.8.0_25-fcs.x86_64
    #jdk-1.7.0_71-fcs.x86_64
    #jdk-1.6.0_45-fcs.x86_64
    #jdk-1.5.0_22-fcs.x86_64
    #32-bit
    #jdk1.8.0_25-1.8.0_25-fcs.i586
    #jdk-1.7.0_71-fcs.i586
    #jdk-1.6.0_45-fcs.i586
    #jdk-1.5.0_22-fcs.i586
    
    #Puppet package names
    #annoyingly the package name for 1.8 is jdk1.8.0_25
    #then more annoyingly the package names for 1.7, 1.6 and 1.5 are jdk
    #Ensure values:
    #1.8 is 1.8.0_25-fcs
    #1.7 is 1.7.0_71-fcs
    #1.6 is 1.6.0_45-fcs
    #1.5 is 1.5.0_22-fcs
    #this means java 8 will not replace 6 or 7 due to the differing packaging names
     
}