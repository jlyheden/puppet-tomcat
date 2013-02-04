class tomcat::params {
  case $::lsbdistcodename {
    'lucid': {
      $allowed_versions = [ '6', '7' ]
      $jvm_params_file = {
        '6' => '/etc/default/tomcat6',
        '7' => '/etc/default/tomcat7'
      }
      $config_dir = {
        '6' => '/etc/tomcat6',
        '7' => '/etc/tomcat7'
      }
      $users_file = 'tomcat-users.xml'
      $server_xml = 'server.xml'
      $user = {
        '6' => 'tomcat6',
        '7' => 'tomcat7'
      }
      $group = {
        '6' => 'tomcat6',
        '7' => 'tomcat7'
      }
      $package = {
        '6' => [ 'tomcat6', 'tomcat6-common', 'libtomcat6-java' ],
        '7' => 'tomcat7'
      }
      $package_extra = {
        '6' => [ 'tomcat6-admin', 'tomcat6-docs', 'tomcat6-user' ],
        '7' => undef
      }
      $service = {
        '6' => 'tomcat6',
        '7' => 'tomcat7'
      }
      $service_hasstatus = true
    }
    default: {
      fail("Unsupported distribution ${::lsbdistcode}")
    }
  }
}
