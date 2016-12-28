include httpd

/* Test Scenarios */
/*
 * CentOS6 manifest run via vagrant VM
 */

/*
 * CentOS7 manifest run via vagrant VM
 */

/*
 * Ubuntu 15.10 manifest run via vagrant VM
 */

/*
 * Navigate to the IP address from the vagrant file, ensure that we get a 200 OK from apache
 * * CentOS6
 * * CentOS7
 * * Ubuntu 15.10
 */
 
/* Future Scenarios */
/*
 * Navigate to the IP address from the vagrant file and append a made up page name to generate an error.
 * Check that the OS version information isn't present
 * * CentOS6
 * * CentOS7
 * * Ubuntu 15.10
 */

/*
 * Navigate to the IP address from the vagrant file and append a made up page name to generate an error.
 * Check that Apache version information isn't present
 * * CentOS6
 * * CentOS7
 * * Ubuntu 15.10
 */

/*
 * Navigate to the IP address from the vagrant file and append a made up page name to generate an error.
 * Check that a custom 404 error page is returned
 * * CentOS6
 * * CentOS7
 * * Ubuntu 15.10

 */
/*
 * Setup a host file for your virtualhost name mapped to the to the IP address from the vagrant file.
 * Navigate to the IP address from the vagrant file.
 * Ensure you are presented with the correctly named/titled homepage
 * * CentOS6
 * * CentOS7
 * * Ubuntu 15.10
 */