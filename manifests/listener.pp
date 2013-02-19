# = Define: tomcat::listener
#
# Manages a Tomcat listener
#
# == Parameters:
#
# [*parameters*]
#   Hash of parameters to pass to listener.
#
# == Sample usage:
#
# tomcat::listener { 'org.apache.catalina.core.AprLifecycleListener':
#   parameters => {
#     'SSLEngine' => 'On'
#   }
# }
#
define tomcat::listener ( $parameters = {} ) {
  validate_hash($parameters)
  if size($name) == 0 {
    fail("Namevar must not be empty.")
  } 
  concat::fragment { "12_listener_${name}":
    target  => $tomcat::tomcat_server_xml,
    content => template('tomcat/listener.erb'),
    order   => 12
  }
}
