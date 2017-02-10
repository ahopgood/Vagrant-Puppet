Package{
  allow_virtual => false,
}

java {"java-6":
  major_version => "6",
  update_version => "45",
  multiTenancy => true,
}
->
java::jce {"jce":
  major_version => "6",
  update_version => "45",
}
->
java {"java-7":
  major_version => "7",
  update_version => "76",
  multiTenancy => true,
}
->
java::jce {"jce7":
  major_version => "7",
  update_version => "76",
}
->
java {"java-8":
  major_version => "8",
  update_version => "31",
  multiTenancy => true,
}
->
java::jce {"jce8":
  major_version => "8",
  update_version => "31",
}