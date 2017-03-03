module Test_ddclientconf = 

let conf ="
protocol=namecheap
use=web, web=dynamicdns.park-your-domain.com/getip
ssl=yes
server=dynamicdns.park-your-domain.com
login=alexanderhopgood.com
password='ffffffffffffffffffffffffffffffff'
@.alexanderhopgood.com,www.alexanderhopgood.com

protocol=namecheap
use=web, web=dynamicdns.park-your-domain.com/getip
ssl=yes
server=dynamicdns.park-your-domain.com
login=altairbob.com
password='00000000000000000000000000000000'
@.altairbob.com,www.altairbob.com
"

test DDClientConf.lns get conf =
{ "1"
    { "prootocol" = "namecheap" }
    { "use" = "web"
        { "web" = "dynamicdns.park-your-domain.com/getip" } }
    { "ssl" = "yes" }
    { "server" = "dynamicdns.park-your-domain.com" }
    { "login" = "alexanderhopgood.com" } 
    { "password" = "ffffffffffffffffffffffffffffffff" }
    { "@.alexanderhopgood.com,www.alexanderhopgood.com" } }
{}
{ "2"
    { "prootocol" = "namecheap" }
    { "use" = "web"
        { "web" = "dynamicdns.park-your-domain.com/getip" } }
    { "ssl" = "yes" }
    { "server" = "dynamicdns.park-your-domain.com" }
    { "login" = "altairbob.com" } 
    { "password" = "00000000000000000000000000000000" }
    { "@.altairbob.com,www.altairbob.com" } } 