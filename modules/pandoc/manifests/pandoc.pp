$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"
Package{
  allow_virtual => false,
}

file {
  "/etc/puppet/installers/":
    ensure     =>  directory,
}
->
class{"pandoc":
}
->
pandoc::texlive-fonts-recommended{"texlive-fonts-recommended":}
->
pandoc::texlive-latex-extra{"texlive-latex-extra":}