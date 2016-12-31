define httpd::xclacks {
/*
  Using augeas we need to add the following to a .htaccess files
  <IfModule headers_module>
    header set X-Clacks-Overhead "GNU Terry Pratchett"
  </IfModule>

 We need to create a .htaccess file.
  
 After investigating .htaccess files a bit it seems they are frowned upon and are not enabled by default in apache versions 2.3.9 and later.
 Instead we should add the text to the httpd.conf file inside a Directory tag.
 <Directory "/var/www/html/">
  <IfModule headers_module>
    header set X-Clacks-Overhead "GNU Terry Pratchett"
  </IfModule>
 </Directory>

  We need to also enable the headers_module in apache by using a2enmod followed by the input headers
  sudo a2enmod --force headers
  This will prevent it asking for input
  This actually creates the following link in /etc/apache/mods-enabled/
  lrwxrwxrwx 1 root root 30 Dec 30 15:44 headers.load -> ../mods-available/headers.load
  Some plugins require a .conf file as well.
  Then we need to restart the apache service (varies based on os)

*/
  exec {"enable headers plugin":
    path => "/usr/sbin/:/usr/bin/",
    command => "a2enmod --force headers",
    returns => 13,
    user => vagrant,
    unless => "/bin/ls -l /etc/apache2/mods-enabled/ | /bin/grep headers",
    require => Package["apache2"],
    notify => Service["apache2"],
  }
  
  
  
  #apache2ctl -M | grep headers
  #ls -l /etc/apache2/mods-enabled/ | grep headers
}