node default {
  # file {'/tmp/example-ip':                                            # resource type file and filename
  #   ensure  => present,                                               # make sure it exists
  #   mode    => 0644,                                                  # file permissions
  #   content => "Here is my Public IP Address: ${ipaddress_eth0}.\n",  # note the ipaddress_eth0 fact
  # }

  /* sudo::sudoers { 'robustus': */
  /*   ensure => 'present', */
  /*   users => [ 'robustus' ], */
  /*   runas => [ 'root' ], */
  /*   cmnds => [ 'ALL' ], */
  /*   tags => [ ], */
  /*   defaults => [ 'env_keep += "SSH_AUTH_SOCK"' ] */
  /* } */

  /* include presenter */
  include hets
}
