Package{
  allow_virtual => false,
}
define java::centos(
  $major_version = "6",
  $update_version = "45",
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
      if (versioncmp("${major_version}", "6") > 0){
        $platform = x64
      } else {
        $platform = amd64
      }
    } else {
      $platform = i586
    }
  
    notify {"Using operating system:$::operatingsystem for Java version ${major_version}":}
    if (versioncmp("${major_version}", "5")==0){
      $jdk = "jdk-1_${major_version}_0_${update_version}-linux-${platform}.rpm"
    } elsif (versioncmp("${major_version}", "6")==0){
      $jdk = "jdk-${major_version}u${update_version}-linux-${platform}.rpm"
    } else {
      $jdk = "jdk-${major_version}u${update_version}-linux-${platform}.rpm"
    }
    
    #Derive package name from version and update version
    #Java 8 rpm package name is different from previous versions so a straight up upgrade won't happen
    #you'll end up with both versions installed so we need to ensure the previous version is absent
    #if version is 5,6,7 (i.e. less than 8
    if (versioncmp("${major_version}", "8") < 0){
#      $package_name  = "jdk"

      # package name = jdk1.8.0_31
      # package version = 1.8.0_31-fcs
      $package_name = "jdk-1.${major_version}.0_${update_version}-fcs.x86_64"
      $package_version = "1.${major_version}.0_${update_version}-fcs"
      #rpm package version = jdk1.8.0_112-1.8.0_112-fcs.x86_64
    } elsif (versioncmp("${major_version}", "8") == 0){
      $package_name  = "jdk1.${major_version}.0_${update_version}"
      $package_version = "1.${major_version}.0_${update_version}-fcs"
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
      $removeOldJavaPackages = "rpm -e $(rpm -qa | grep jdk*${major_version}* | grep -v '${package_name}')"
      $checkOldPackagesExist = "rpm -qa | grep jdk*${major_version}* | grep -v '${package_name}'"

    } else {
      notify{"Multi-tenancy not allowed":}
      #Hack: duplicate notify declaration prevents multiple major versions being installed.
      $install_options = ['--force'] #required for downgrading packages
      #when single tenancy we can use a wildcard match to remove **all** previous versions.
      $removeOldJavaPackages = "rpm -e $(rpm -qa | grep jdk* | grep -v '${package_name}')"
      $checkOldPackagesExist = "rpm -qa | grep jdk* | grep -v '${package_name}'"
      $versionsToRemove = {
        "6" => ["jdk1.7.0_*","jdk1.8.0_*"],
        "7" => ["jdk1.6.0_.*","jdk1.8.0_.*"],
        "8" => ["jdk1.6.0_.*","jdk1.7.0_.*"],
      }
    }

    package {
      "${package_name}":
      ensure      => "${package_version}",
#      ensure      => installed,
      provider    =>  'rpm',
      source      =>  "${local_install_dir}${jdk}",
      require     =>  File["${jdk}"],
      install_options => $install_options,
    }
    ->
    exec {"remove-other-versions-of-java-${major_version}":
      path => "/bin/",
      command => $removeOldJavaPackages,
      onlyif => $checkOldPackagesExist,
      #Removing the java package via rpm fails to clear up alternatives
    }
    ->
    java::default::remove{$versionsToRemove["${major_version}"]:
      major_version => "${major_version}", 
    }

#  sudo alternatives --remove java /usr/java/jdk1.7.0_76/jre/bin/java


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