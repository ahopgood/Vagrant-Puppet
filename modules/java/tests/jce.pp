Package{
  allow_virtual => false,
}

java {"java-6":
  major_version => "6",
  update_version => "45",
}
->
java::jce {"jce":
  major_version => "6",
  update_version => "45",
}