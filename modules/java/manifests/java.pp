Package{
  allow_virtual => false,
}

class { 'java':
  version => '7',
  updateVersion => '76'
#  is64bit => 'false'
}