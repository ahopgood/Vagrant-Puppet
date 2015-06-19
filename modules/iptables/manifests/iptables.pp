
class { 'iptables':
  port => '8080',
  isTCP => true
}