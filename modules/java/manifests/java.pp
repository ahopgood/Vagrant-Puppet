Package{
  allow_virtual => false,
}

class { 'java':
  version => '8',
  updateVersion => '31'
#  is64bit => 'false'
}