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
  $connector_content = inline_template("  <Listener className=\"<%= name %>\" <%- parameters.sort_by { |k,v| k}.each { |v| -%><%= v[0] %>=\"<%= v[1] %>\" <%- } -%>/>\n")
  concat::fragment { "12_listener_${name}":
    target  => $tomcat::tomcat_server_xml,
    content => $connector_content,
    order   => 12
  }
}