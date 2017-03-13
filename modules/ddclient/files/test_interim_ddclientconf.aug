module Test_ddclientconf = 

let conf ="
protocol=namecheap
use=web
ssl=yes
server=dynamicdns.park-your-domain.com
login=alexanderhopgood.com
password='ffffffffffffffffffffffffffffffff'

protocol=namecheap
use=web
ssl=yes
server=dynamicdns.park-your-domain.com
login=altairbob.com
password='00000000000000000000000000000000'
"

test Ddclientconf.lns get conf =
{ "1"
    { "prootocol" = "namecheap" }
    { "use" = "web"
    { "ssl" = "yes" }
    { "server" = "dynamicdns.park-your-domain.com" }
    { "login" = "alexanderhopgood.com" } 
    { "password" = "ffffffffffffffffffffffffffffffff" } }
{}
{ "2"
    { "prootocol" = "namecheap" }
    { "use" = "web"
    { "ssl" = "yes" }
    { "server" = "dynamicdns.park-your-domain.com" }
    { "login" = "altairbob.com" } 
    { "password" = "00000000000000000000000000000000" } } 