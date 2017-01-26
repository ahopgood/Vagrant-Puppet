class tomcat::ubuntu{

  if ("${operatingsystemmajrelease}" == "15.10"){
    
  } else {
    fail("Currently the ${class_name} doesn't support ${operatingsystem}")
  }
}
