module Test_interim_ddclientconf =

let conf ="protocol=namecheap
use=web, web=dynamicdns.park-your-domain.com/getip
ssl=yes
server=dynamicdns.park-your-domain.com
login=alexanderhopgood.com
password='ffffffffffffffffffffffffffffffff'
www.alexanderhopgood.com,@.alexanderhopgood.com,@.sub.alexanderhopgood.com

protocol=namecheap
use=web, web=dynamicdns.park-your-domain.com/getip
ssl=yes
server=dynamicdns.park-your-domain.com
login=altairbob.com
password='00000000000000000000000000000000'
@.altairbob.com
"

test Ddclientconf.lns get conf =
{ "1"
    { "protocol" = "namecheap" }
    { "use" = "web, web=dynamicdns.park-your-domain.com/getip" }
    { "ssl" = "yes" }
    { "server" = "dynamicdns.park-your-domain.com" }
    { "login" = "alexanderhopgood.com" } 
    { "password" = "'ffffffffffffffffffffffffffffffff'" }
    { "domain" = "www.alexanderhopgood.com,@.alexanderhopgood.com,@.sub.alexanderhopgood.com" } }
{}
{ "2"
    { "protocol" = "namecheap" }
    { "use" = "web, web=dynamicdns.park-your-domain.com/getip" }
    { "ssl" = "yes" }
    { "server" = "dynamicdns.park-your-domain.com" }
    { "login" = "altairbob.com" }
    { "password" = "'00000000000000000000000000000000'" }
    { "domain" = "@.altairbob.com" } }