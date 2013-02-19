# == Define: tomcat::role
#
# Manages a Tomcat role
#
# === Parameters:
#
# === Sample usage:
#
# tomcat::role { 'admin': }
#
define tomcat::role {
  if size($name) == 0 {
    fail('Namevar must not be empty.')
  }
  concat::fragment { "20_tomcat_users_xml_${name}":
    target  => $tomcat::tomcat_users_file,
    content => "<role rolename=\"${name}\"/>\n",
    order   => 20
  }
}
