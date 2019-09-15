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
pandoc::texlive_fonts_recommended{"texlive_fonts_recommended":}
# ->
# pandoc::texlive_latex_extra{"texlive_latex_extra":}