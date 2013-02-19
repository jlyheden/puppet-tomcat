# = Class: tomcat::profile::apr
#
# Convenience class that adds APR support
#
# == Parameters:
#
# == Sample usage:
#
# include tomcat::profile::apr
#
class tomcat::profile::apr ( $sslengine = 'UNDEF' ) {

  include tomcat::params

  $valid_sslengine_values = [ 'On', 'Off' ]

  $sslengine_real = $sslengine ? {
    'UNDEF' => 'On',
    true    => 'On',
    false   => 'Off',
    default => $sslengine
  }

  validate_re($sslengine_real,$valid_sslengine_values)

  package { 'tomcat/packages/apr':
    name  => $tomcat::params::package_apr
  }

  tomcat::listener { 'org.apache.catalina.core.AprLifecycleListener':
    parameters    => {
      'SSLEngine' => $sslengine_real
    },
    require       => Package['tomcat/packages/apr']
  }

}
