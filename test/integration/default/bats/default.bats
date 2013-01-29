#!/usr/bin/env bats

@test "creates /etc/ipa/default.conf file" {
  [ -f "/etc/ipa/default.conf" ]
}

@test "responds to http" {
  run /usr/lib64/nagios/plugins/check_http -S -H `hostname -f` -u /ipa/ui/
  [ "$status" -eq 0 ]
}

@test "responds to dns" {
  run /usr/lib64/nagios/plugins/check_dns --server=`hostname -f` -H `hostname -f`
  [ "$status" -eq 0 ]
}

@test "responds to ldap" {
  run /usr/lib64/nagios/plugins/check_ldap -H `hostname -f` -b 'dc=vagrantup,dc=com'
  [ "$status" -eq 0 ]
}

@test "responds to ntp" {
  run /usr/lib64/nagios/plugins/check_ntp_peer -H localhost
  [ "$status" -eq 0 ]
}

# responds from the ca server
# responds from the krb5 server
# responds from the memcached server
#
# can add a user
# can change a password
# can remove a user
# can add a group
# can add a user to a group
# can remove a user to a group
# can delete a group
#
# can add an a record domain
# can add an cname record domain
# can remove a domain
#
# should replicate to another master
# should restore from a backup
# should backup
#
# should manage sudo access
# should manage ssh access
# should manage ssh access
