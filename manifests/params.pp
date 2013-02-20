# = Class: tomcat::params
#
# Settings class
#
# == Parameters:
#
# == Sample Usage:
#
# include tomcat::params
#
class tomcat::params {
  case $::lsbdistcodename {
    'lucid': {
      $allowed_versions = [ '6', '7' ]
      $context_descriptor_subdir = 'Catalina/localhost'
      $home_folder = {
        '6' => '/usr/share/tomcat6',
        '7' => '/usr/share/tomcat7'
      }
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
        '7' => [ 'tomcat7', 'tomcat7-common', 'libtomcat7-java' ],
      }
      $package_apr = 'libtcnative-1'
      $package_extra = {
        '6' => [ 'tomcat6-admin', 'tomcat6-docs', 'tomcat6-user' ],
        '7' => [ 'tomcat7-admin', 'tomcat7-docs', 'tomcat7-user' ],
      }
      $service = {
        '6' => 'tomcat6',
        '7' => 'tomcat7'
      }
      $service_hasstatus = true
    }
    default: {
      fail("Unsupported distribution ${::lsbdistcodename}")
    }
  }
}
