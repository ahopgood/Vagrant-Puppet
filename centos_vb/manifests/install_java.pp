  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "installer_files/"
  
#Check file exists either in the puppet file server or locally in a vagrant shared folder
$jdk = "jdk-6u45-linux-amd64.rpm"
file {
    "${local_install_dir}":
    path    =>  "${local_install_dir}",
    ensure  =>  directory,
}

file {
    "${jdk}":
    require     =>  File["${local_install_dir}"],
    path        =>  "${local_install_dir}${jdk}",
    ensure      =>  present,
    source      =>  ["puppet:///${puppet_file_dir}${jdk}"],
}

package	{
	'jdk':
	ensure      =>  present,
  provider    =>  'rpm',
  source      =>  "${local_install_dir}${jdk}",
  require     =>  File["${jdk}"],
}

#It might be worth setting up an alternatives type instead of relying on the exec command.
exec {
  'java-install-alternative':
  command     =>  "alternatives --install /usr/bin/java java /usr/java/jdk1.6.0_45/jre/bin/java 20000",
  path        =>  '/usr/sbin/',
  cwd         =>  '/usr/sbin/',
  require     =>  Package['jdk'],
  before      =>  Exec['java-set-alternative']
}

exec {
  'jar-install-alternative':
  command     =>  'alternatives --install /usr/bin/jar jar /usr/java/jdk1.6.0_45/bin/jar 20000',
  path        =>  '/usr/sbin/',
  cwd         =>  '/usr/sbin/',
  require     =>  Package['jdk'],
  before      =>  Exec['jar-set-alternative']  
}

exec {
  'javac-install-alternative':
  command     =>  'alternatives --install /usr/bin/javac javac /usr/java/jdk1.6.0_45/bin/javac 20000',
  path        =>  '/usr/sbin/',
  cwd         =>  '/usr/sbin/',
  require     =>  Package['jdk'],
  before      =>  Exec['javac-set-alternative']
}
  
exec {
  'javaws-install-alternative':
  command     =>  'alternatives --install /usr/bin/javaws javaws /usr/java/jdk1.6.0_45/jre/bin/javaws 20000',
  path        =>  '/usr/sbin/',
  cwd         =>  '/usr/sbin/',
  require     =>  Package['jdk'],
  before      =>  Exec['javaws-set-alternative']
}

exec {
  'java-set-alternative':
  command     =>  'alternatives --set java /usr/java/jdk1.6.0_45/jre/bin/java',
  path        =>  '/usr/sbin/',
  cwd         =>  '/usr/sbin/',
}   

exec {
  'jar-set-alternative':
  command     =>  'alternatives --set jar /usr/java/jdk1.6.0_45/bin/jar',
  path        =>  '/usr/sbin/',
  cwd         =>  '/usr/sbin/',  
}

exec {
  'javac-set-alternative':
  command     =>  'alternatives --set javac /usr/java/jdk1.6.0_45/bin/javac',  
  path        =>  '/usr/sbin/',
  cwd         =>  '/usr/sbin/',
}

exec {
  'javaws-set-alternative':
  command     =>  'alternatives --set javaws /usr/java/jdk1.6.0_45/jre/bin/javaws',
  path        =>  '/usr/sbin/',
  cwd         =>  '/usr/sbin/',
}

#  subscribe   =>  Package['java-sdk'],
#  require     =>  Package['java-sdk'],
