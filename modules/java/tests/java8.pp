Package{
  allow_virtual => false,
}
java::jce {"jce8":
  major_version => "8",
  update_version => "31",
}