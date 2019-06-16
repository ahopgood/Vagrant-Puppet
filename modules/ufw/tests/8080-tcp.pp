Package{
  allow_virtual => false
}
  ufw {"test":
    port => '8080',
    isTCP => true
  }
  ->
  ufw::service{"ufw-service":}
#To check the rule is applied run:
#sudo ufw status | grep "8080/tcp .* ALLOW"