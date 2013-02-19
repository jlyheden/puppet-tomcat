# = Class: tomcat
#
# This module manages tomcat
#
# == Parameters:
#
# [*version*]
#   Version of Tomcat. Valid versions are listed in tomcat::params
#
# [*autoupgrade*]
#   Boolean if Tomcat should auto upgrade.
#
# [*jvm_parameters*]
#   Array of jvm parameters when starting Tomcat
#
# [*server_xml_source*]
#   Optional path to server.xml
#
# [*service_enable*]
#   Boolean if Tomcat service should be enabled on boot
#
# [*service_status*]
#   Ensure setting for Tomcat service.
#
# == Requires: see Modulefile
#
# == Sample Usage:
#
#   class { 'tomcat':
#     version => '7',
#     jvm_parameters => [ '-Xmx64m', '-Xms32m' ],
#   }
#
class tomcat (
  $version            = 'UNDEF',
  $autoupgrade        = 'UNDEF',
  $jvm_parameters     = 'UNDEF',
  $server_xml_source  = 'UNDEF',
  $service_enable     = 'UNDEF',
  $service_status     = 'UNDEF'
) {

  include tomcat::params

  $service_status_real = $service_status ? {
    'UNDEF'               => running,
    /^(running|stopped)$/ => $service_status,
    'unmanaged'           => undef,
    default               => fail("Invalid parameter value ${service_status}. Valid values: running, stopped, unmanaged")
  }
  $service_enable_real = $service_enable ? {
    'UNDEF' => true,
    default => $service_enable
  }
  $jvm_parameters_real = $jvm_parameters ? {
    'UNDEF' => [ '-Djava.awt.headless=true', '-Xmx128m' ],
    default => $jvm_parameters
  }
  $autoupgrade_real = $autoupgrade ? {
    'UNDEF' => present,
    true    => latest,
    default => present
  }
  $version_real = $version ? {
    'UNDEF' => '6',
    default => $version
  }
  $server_xml_source_real = $server_xml_source ? {
    'UNDEF' => undef,
    default => $server_xml_source
  }

  validate_re($version_real,$tomcat::params::allowed_versions)
  validate_array($jvm_parameters_real)
  validate_bool($service_enable_real)

  $tomcat_config_dir_real = $tomcat::params::config_dir[$version_real]
  $tomcat_user_real = $tomcat::params::user[$version_real]
  $tomcat_group_real = $tomcat::params::group[$version_real]
  $tomcat_package_real = $tomcat::params::package[$version_real]
  $tomcat_server_xml = "${tomcat_config_dir_real}/${tomcat::params::server_xml}"
  $tomcat_users_file = "${tomcat_config_dir_real}/${tomcat::params::users_file}"
  $tomcat_home_folder = $tomcat::params::home_folder[$version_real]

  case $::operatingsystem {
    ubuntu: {
      include tomcat::debian
    }
    debian: {
      include tomcat::debian
    }
    default: {}
  }

  if $server_xml_source_real == undef {
    concat { $tomcat_server_xml:
      path    => $tomcat_server_xml,
      owner   => root,
      group   => $tomcat_group_real,
      mode    => '0640',
      require => Package['tomcat/packages'],
      notify  => Service['tomcat/service']
    }
    concat::fragment { '10_server_xml':
      target  => $tomcat_server_xml,
      source  => "puppet:///modules/tomcat/${version_real}/10_server.xml",
      order   => 10
    }
    concat::fragment { '15_server_xml':
      target  => $tomcat_server_xml,
      source  => "puppet:///modules/tomcat/${version_real}/15_server.xml",
      order   => 15
    }
    concat::fragment { '30_server_xml':
      target  => $tomcat_server_xml,
      source  => "puppet:///modules/tomcat/${version_real}/30_server.xml",
      order   => 30
    }
  }
  else {
    file { $tomcat_server_xml:
      ensure  => present,
      owner   => root,
      group   => $tomcat_group_real,
      mode    => '0640',
      source  => $server_xml_source,
      require => Package['tomcat/packages'],
      notify  => Service['tomcat/service']
    }
  }

  concat { $tomcat_users_file:
    path    => $tomcat_users_file,
    owner   => root,
    group   => $tomcat_group_real,
    mode    => '0640',
    require => Package['tomcat/packages'],
    notify  => Service['tomcat/service']
  }
  concat::fragment { '10_tomcat_users_xml':
    target  => $tomcat_users_file,
    content => "<?xml version='1.0' encoding='utf-8'?>\n<tomcat-users>\n",
    order   => 10,
  }
  concat::fragment { '40_tomcat_users_xml':
    target  => $tomcat_users_file,
    content => "</tomcat-users>\n",
    order   => 40
  }

  file { 'tomcat/configdir':
    ensure  => directory,
    path    => $tomcat_config_dir_real,
    owner   => root,
    group   => $tomcat_group_real,
    mode    => '0750'
  }

  package { 'tomcat/packages':
    ensure  => $autoupgrade_real,
    name    => $tomcat::params::package[$version_real],
    before  => Service['tomcat/service']
  }

  service { 'tomcat/service':
    ensure    => $service_status_real,
    name      => $tomcat::params::service[$version_real],
    enable    => $service_enable_real,
    hasstatus => $tomcat::params::service_hasstatus,
    require   => Package['tomcat/packages']
  }

}
