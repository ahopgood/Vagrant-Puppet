#Requires install_java.pp to be run
#Also requires setup_fileserver.pp to be run if desiring install files from the pupper master server.
#Make this class behave differently based on OS type

class install_tomcat {
  $vagrant_share      = "/installers/"
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "installer_files/"
  
  $tomcat_install_dir = "/var/hosting/"
  $tomcat_full_ver    = "apache-tomcat-7.0.54"
  $tomcat_short_ver   = "tomcat7"
  $tomcat_file        = "${tomcat_full_ver}.tar.gz"
  $tomcat_installer   = "unpack_tomcat.sh"
  $tomcat_password    = "tomcat"

  user { 'tomcat':
    ensure      =>  present,
    home        =>  "/home/tomcat",
    managehome  =>  true,
    shell       =>  '/bin/bash',
    #password  =>  '$1$Gphy4jMa$WrTbubXCbIKjdaFHkcJX91'
  }

  #Create the directory we will install tomcat into.
  file {
    [ "${tomcat_install_dir}" ]:
    ensure    =>  directory,
    mode      =>  0644,
    owner     =>  'tomcat',
  }
  
  #Create the directory that the local install files will be copied to from the puppet fileserver or vagrant shared folder 
  file {
    [ "${local_install_dir}" ]:
    ensure    =>  directory,
    mode      =>  0644,
    owner     =>  'tomcat',
  }

  file {
    "${tomcat_file}":
    path    =>  "${local_install_dir}${tomcat_file}",
    ensure  =>  present,
    mode    =>  0777,
    owner   =>  'tomcat',      
    source  =>  ["puppet:///${puppet_file_dir}${tomcat_file}",
                    "${vagrant_share}${tomcat_file}"],
    require =>  File["${local_install_dir}"],
  } 
  
  /* 
  file {
    "${tomcat_installer}":
    path    =>  "${local_install_dir}${$tomcat_installer}",
    ensure  =>  present,
    mode    =>  0774,
    owner   =>  'tomcat',    
    source  =>  ["puppet:///${puppet_file_dir}${$tomcat_installer}",
                  "${vagrant_share}${tomcat_installer}"],
    require =>  File["${tomcat_file}"],
  }
  

  exec {
    "Unpack tomcat archive":
    path      =>  "${local_install_dir}",
    command   =>  "${local_install_dir}${tomcat_installer}",
    require   =>  File["${tomcat_installer}"],
  }

  exec {
    "Uncompress tomcat archive":
    path      =>  "/bin/",
    command   =>  "gzip -d ${local_install_dir}${$tomcat_file}",
    user      =>  "tomcat",
  }
*/
  exec {
    "Unpack tomcat archive":
    path      =>  "/bin/",
    command   =>  "tar xfvz ${local_install_dir}${tomcat_file}.tar.gz",
    user      =>  "tomcat",
    require   =>  File["${tomcat_file}"],
  }

  exec {
    "Rename to tomcat7":
    path      =>  "/bin/",
    command   =>  "mv ${local_install_dir}${tomcat_full_ver} ${tomcat_install_dir}${tomcat_short_ver}",
    user      =>  "tomcat",
    require   =>  "Unpack tomcat archive",
  }
  /*
  exec {
    "Copy to install directory":
    path      =>  "/bin/",
    command   =>  "cp -R ${local_install_dir}${tomcat_short_ver} ${tomcat_install_dir}",
    user      =>  "tomcat",
  }
  
  exec {
    "Copy to install directory":
    path      =>  "/bin/",
    command   =>  "mv ${local_install_dir}${tomcat_short_ver} ${tomcat_install_dir}",
    user      =>  "tomcat",
  }
  */
  exec {
    "Set folder permissions":
    path      =>  "/bin/",
    command   =>  " ${local_install_dir}${tomcat_short_ver}",
  }
  
  file {
    "Set JAVA_HOME":
    path      =>  "/etc/profile.d/java.sh",
    content   =>  "export JAVA_HOME=/usr/java/default",
    require   =>  Exec["Unpack tomcat archive"],
  }

  file {
    "Set CATALINA_HOME":
    path      =>  "/etc/profile.d/catalina-home.sh",
    content   =>  "export CATALINA_HOME=${$tomcat_install_dir}${tomcat_short_ver}",
    require   =>  File["Set JAVA_HOME"],
  }
  
  file  {
    "Logging Directory":
    path      =>  "${$tomcat_install_dir}${tomcat_short_ver}/logs",
    ensure    =>  directory,
    mode      =>  0644,
    owner     =>  'tomcat',
    recurse   =>   true,
    require   =>  File["Set CATALINA_HOME"],
  }
  
  exec {
    "Start tomcat":
    path      =>  "/usr/bin/",
    command   =>  "${$tomcat_install_dir}${tomcat_short_ver}/bin/startup.sh",
    require   =>  File["Logging Directory"],
    user      =>  "tomcat",
  }
}

include install_tomcat












