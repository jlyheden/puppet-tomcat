# = Define: tomcat::connector
#
# Manages a Tomcat connector
#
# == Parameters:
#
# [*parameters*]
#   Hash of parameters to pass to connector. See http://tomcat.apache.org/tomcat-6.0-doc/config/http.html
#   or http://tomcat.apache.org/tomcat-7.0-doc/config/http.html
#
# == Sample usage:
#
# tomcat::connector { '8080_connector':
#   parameters => {
#     'port'              => 8080,
#     'protocol'          => 'HTTP/1.1',
#     'connectionTimeout' => 20000,
#   }
# }
#
define tomcat::connector ( $parameters ) {
  validate_hash($parameters)
  $connector_content = inline_template('  <Connector <%- parameters.sort_by { |k,v| k}.each { |v| -%><%= v[0] %>="<%= v[1] %>" <%- } -%>/>')
  concat::fragment { "20_connector_${name}":
    target  => $tomcat::tomcat_server_xml,
    content => $connector_content,
    order   => 20
  }
}
