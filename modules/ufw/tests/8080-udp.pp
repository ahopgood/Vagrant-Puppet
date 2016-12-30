Package{
  allow_virtual => false
}
  ufw {"test":
    port => '8080',
    isTCP => false
  }
#To check the rule is applied run:
#sudo ufw status | grep "8080/udp .* ALLOW"