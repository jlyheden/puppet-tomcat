# = Define: tomcat::connector
#
# Manages a Tomcat connector
#
# == Parameters:
#
# [*parameters*]
#   Hash of parameters to pass to connector.
#   See http://tomcat.apache.org/tomcat-6.0-doc/config/http.html
#   or http://tomcat.apache.org/tomcat-7.0-doc/config/http.html
#
# == Sample usage:
#
# tomcat::connector { '8090_connector':
#   parameters => {
#     'port'              => 8090,
#     'protocol'          => 'HTTP/1.1',
#     'connectionTimeout' => 40000,
#   }
# }
#
define tomcat::connector ( $parameters ) {
  validate_hash($parameters)
  concat::fragment { "20_connector_${name}":
    target  => $tomcat::tomcat_server_xml,
    content => template('tomcat/connector.erb'),
    order   => 20
  }
}
