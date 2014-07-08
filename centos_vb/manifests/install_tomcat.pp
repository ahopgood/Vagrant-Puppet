#Requires install_java.pp to be run
#Also requires setup_fileserver.pp to be run if desiring install files from the pupper master server.
#Make this class behave differently based on OS type

class install_tomcat {
  $vagrant_share      = "/installers/"
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "installer_files/"

  $tomcat_file      = "apache-tomcat-7.0.54.tar.gz"
  $tomcat_ver       = "tomcat7"
  $tomcat_installer = "unpack_tomcat.sh"
  $tomcat_password  = "tomcat"

  user { 'tomcat':
    ensure      =>  present,
    home        =>  "/home/tomcat",
    managehome  =>  true,
    shell       =>  '/bin/bash',
    #password  =>  '$1$Gphy4jMa$WrTbubXCbIKjdaFHkcJX91'
  }

  file {
    [ "/var/hosting/" ]:
    ensure    =>  directory,
    mode      =>  0644,
    owner     =>  'tomcat',
  }

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

  exec{
    "Unpack tomcat archive":
    path      =>  "${local_install_dir}",
    command   =>  "${local_install_dir}${tomcat_installer}",
    require   =>  File["${tomcat_installer}"],
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
    content   =>  "export CATALINA_HOME=/var/hosting/${tomcat_ver}",
    require   =>  File["Set JAVA_HOME"],
  }
  
  exec {
    "Start tomcat":
    path      =>  "/usr/bin/",
    command   =>  "/var/hosting/tomcat7/bin/startup.sh",
    require   =>  File["Set CATALINA_HOME"],
    user      =>  "tomcat",
  }
}

include install_tomcat












