class module_copy {
  $module_path        = "/etc/puppet/modules/"
  
  exec {
    "Copy modules": 
    path    =>  "/bin/",
    command =>  "cp -R /modules/* ${module_path}",  
  }
}