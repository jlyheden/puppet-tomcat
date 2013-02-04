# == Class: tomcat::debian
#
# Manages specifics for Tomcat in Debian/Ubuntu
#
# === Parameters:
#
# === Sample usage:
#
# include tomcat::debian
#
class tomcat::debian {
  $jvm_parameters = $tomcat::jvm_parameters_real
  $parameter_line = inline_template('JAVA_OPTS="<%= jvm_parameters.join(" ") %>"')
  file_line { 'debian_default_jvm_options':
    ensure  => present,
    line    => $parameter_line,
    path    => $tomcat::params::jvm_params_file[$tomcat::version_real],
    require => Package['tomcat/packages'],
    notify  => Service['tomcat/service']
  }
}
