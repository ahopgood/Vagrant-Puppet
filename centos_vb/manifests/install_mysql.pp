  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers"
  $puppet_file_dir    = "installer_files"

  $MySQL_shared_compat = "MySQL-shared-compat-5.6.19-1.el6.x86_64.rpm"
  $MySQL_server = "MySQL-server-5.6.19-1.el6.x86_64.rpm"
  $MySQL_client = "MySQL-client-5.6.19-1.el6.x86_64.rpm"
  $MySQL_shared = "MySQL-shared-5.6.19-1.el6.x86_64.rpm"

  $password     = "root"

#Load the installers from the puppet fileserver into the local filesystem
#Try giving the file a name and separate target location so we don't need to fully qualify the path

file {
    "${MySQL_shared_compat}":
    path    =>  "${local_install_dir}/${MySQL_shared_compat}",
    ensure  =>  present,
    source  =>  ["puppet:///${puppet_file_dir}/${MySQL_shared_compat}"],
}

package {
    'MySQL-shared-compat':
    ensure      =>  installed,
    provider    =>  'rpm',
    source      =>  "${local_install_dir}/${MySQL_shared_compat}",
    require     =>  File["${MySQL_shared_compat}"],
}

package {
  'mysql-libs-5.1.71-1.el6.x86_64':
  ensure      =>  absent,
  provider    =>  'rpm',
  require     =>  Package['MySQL-shared-compat'],
  before      =>  [Package['MySQL-shared'], Package['MySQL-server'], Package['MySQL-client']],
}

file {
  "${MySQL_shared}":
  path        => "${$local_install_dir}/${MySQL_shared}",
  ensure      =>  present,
  source      =>  ["puppet:///${puppet_file_dir}/${MySQL_shared}"],
}

package {
  'MySQL-shared':
  ensure      =>  installed,
  provider    =>  'rpm',
  source      =>  "${local_install_dir}/${MySQL_shared}",
  require     =>  File["${MySQL_shared}"],
}

file {
  "${MySQL_server}":
  path    =>  "${local_install_dir}/${MySQL_server}",
  ensure  =>  present,
  source  =>  ["puppet:///${puppet_file_dir}/${MySQL_server}"],  
}

package {
  'MySQL-server':
  ensure      =>  installed,
  provider    =>  'rpm',
  source      =>  "${local_install_dir}/${MySQL_server}",
  require     =>  File["${MySQL_server}"],
}

file{
  "${MySQL_client}":
  path      => "${local_install_dir}/${MySQL_client}",
  ensure    => present,
  source    => ["puppet:///${puppet_file_dir}/${MySQL_client}"],
}

package {
  'MySQL-client':
  ensure      =>  installed,
  provider    =>  'rpm',
  source      =>  "${local_install_dir}/${MySQL_client}",
  require     =>  File["${MySQL_client}"],
}

#Need to check the service is running first
exec {
  "Stop mysql":
  refreshonly =>  true,
  subscribe   =>  [Package['MySQL-client'], Package['MySQL-server'], Package['MySQL-shared']],
  unless      =>  "/usr/bin/mysqladmin status",
  path        =>  "/usr/bin/mysql",
  command     =>  "/etc/init.d/mysql stop",
#  before      =>  Exec['Skip grant tables'],  
}
#Start the service in safe mode

exec {
  "Skip grant tables":
  path        =>  "/usr/bin/",
  unless      =>  "/usr/bin/mysqladmin status",
  command     =>  "sudo mysqld_safe --skip-grant-tables &", 
  #before      =>  Exec['Set MySQL root password'],
  require     =>  Exec['Stop mysql'],
}

exec {
  "Set MySQL root password":
  path        =>  "/usr/bin/",
  command     =>  "sudo sleep 10 && mysql mysql -e \"update user set password=PASSWORD('$password') where user='root';\"",
  require     =>  Exec['Skip grant tables'],  
}

#stop the service again to drop out of safe mode
exec {
  "Stop mysqld_safe":
  path        =>  "/usr/sbin/mysqld",
  command     =>  "/etc/init.d/mysql stop",
  require     =>  Exec['Set MySQL root password'],
}

#Start service again normally without skipping the grant tables.
exec {
  "Start mysql":
  path        =>  "/usr/bin/mysql",
  command     =>  "/etc/init.d/mysql start",
  require     =>  Exec["Stop mysqld_safe"],
}

#Perform the chkconfig to ensure the service loads on startup?

