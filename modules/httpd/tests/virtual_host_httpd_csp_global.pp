Package{
  allow_virtual => false
}

  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"

  file {
    "${local_install_dir}":
    path       =>  "${local_install_dir}",
    ensure     =>  directory,
  }
  class { "httpd": }

  httpd::virtual_host{"test":
    server_name => "www.alexander.com",
    document_root => "/var/www/alexander/",
    server_alias => ["alexander.com","alexander.net"]
  }
  ->
  file { "/var/www/alexander/":
    ensure => directory,
    #    require => Class["httpd"]
  }
  ->
  file {"/var/www/html/index.html":
    ensure => present,
    content => "
    <html>
      <head>
        <script src=\"https://code.jquery.com/jquery-3.2.1.min.js\"></script>
        <title>Test Page</title>
      </head>
      <body>
        <h1>HTTPD test page</h1>
      </body>
    </html>"
  }
  ->
  class{"augeas":}
  ->
  httpd::xclacks{"x-clacks":}
  ->
  httpd::content_security_policy{"CSP":}