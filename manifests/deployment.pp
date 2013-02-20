# = Define: tomcat::deployment
#
# Manages Tomcat application deployments
# Supports the ability to inject application
# dependencies via resource_name and
# resource_parameters
#
# == Parameters:
#
# [*ensure*]
#   Traditional ensure parameter. Supports present, absent
#
# [*source*]
#   Path to context descriptor source file
#
# [*template*]
#   Template file for context descriptor
#
# [*context_params*]
#   Hash to pass to the Context tag. Should contain key => value
#
# [*context_resources*]
#   Array of nested hashes to build declare resources within context xml
#   See example under Sample Usage
#
# [*application_type*]
#   Application resource to deploy, can be a single file, vcs checkout
#   package deployment etc.
#
# [*application_params*]
#   Application resource parameters to pass to the resource creation
#
# [*application_installs_into*]
#   Path where application installs into. Can be a directory or war file
#
# [*application_restart*]
#   Boolean if changes in the resource should kick the Tomcat service.
#
# == Sample usage:
#
# * Deploying context_root my_application using a custom package
#   for application deployment
# tomcat::deployment { 'my_application':
#   ensure                  => present,
#   application_type        => 'package',
#   application_params      => {
#     'my-custom-my-application-package' => {
#       ensure              => latest,
#     }
#   },
#   application_installs_into => '/some/path',
#   application_restart       => true,
#   context_params            => {
#     'path'                  => '/my/custom/path',
#     'antiResourceLocking'   => 'false',
#   },
#   context_resources         => [
#     { 'Resource'  => {
#       'name'      => 'jdbc/mydatabase',
#       'type'      => 'javax.sql.DataSource',
#       'username'  => 'mydbuser',
#       'password'  => 'mypassword',
#       'driverClassName' => 'com.mysql.jdbc.Driver'
#     } }
#   ]
# }
#
define tomcat::deployment (
  $ensure                     = 'UNDEF',
  $source                     = 'UNDEF',
  $template                   = 'UNDEF',
  $context_params             = {},
  $context_resources          = {},
  $application_type           = 'UNDEF',
  $application_params         = {},
  $application_installs_into  = 'UNDEF',
  $application_restart        = 'UNDEF',
) {

  $ensure_real = $ensure ? {
    'UNDEF'             => present,
    /(present|absent)/  => $ensure,
    default             => fail("Invalid value ${ensure} for parameter ensure. Valid values: present, absent")
  }
  $source_real = $source ? {
    'UNDEF'   => undef,
    default   => $source
  }

  $application_restart_real = $application_restart ? {
    'UNDEF' => Service['tomcat/service'],
    true    => Service['tomcat/service'],
    false   => undef,
    default => fail("Invalid value ${application_restart} for parameter application_restart. Valid values: true, false")
  }

  # Defaults taken from
  # https://help.ubuntu.com/community/Tomcat/PackagingWebapps
  $application_path_real = $application_installs_into ? {
    'UNDEF' => "${tomcat::tomcat_home_folder}/${name}",
    default => $application_installs_into
  }
  $context_params_real = merge({'path' => $name, 'docBase' => $application_path_real}, $context_params)

  $context_file = "${tomcat::tomcat_contexts_dir_real}/${name}.xml"
  if $application_type != 'UNDEF' {
    create_resources($application_type,$application_params)
  }

  $template_real = $template ? {
    'UNDEF'   => template('tomcat/deployment_descriptor.xml.erb'),
    default   => $template
  }

  file { "tomcat_deployment_descriptor_${name}":
    ensure    => $ensure_real,
    path      => $context_file,
    owner     => $tomcat::tomcat_user_real,
    group     => $tomcat::tomcat_group_real,
    mode      => '0640',
    source    => $source_real,
    content   => $template_real,
    notify    => $application_restart_real,
  }

}
