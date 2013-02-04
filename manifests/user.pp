# == Define: tomcat::user
#
# Manages a Tomcat user
#
# === Parameters:
#
# [*password*]
#   Cleartext password for user
#
# [*roles*]
#   Array of roles that user should be member of
#
# === Sample usage:
#
# tomcat::user { 'tomcatuser':
#   password  => 'mypassword',
#   roles     => [ 'role1' ],
# }
#
define tomcat::user ( $password, $roles ) {
  validate_array($roles)
  concat::fragment { "30_tomcat_users_xml_${name}":
    target  => $tomcat::tomcat_users_file,
    content => inline_template("<user username=\"<%= name %>\" password=\"<%= password %>\" roles=\"<%= roles.join(',') %>\"/>\n"),
    order   => 30,
    require => Tomcat::Role[$roles]
  }
}