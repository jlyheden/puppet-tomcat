# = Class: tomcat::profile::default
#
# Convenience class that adds a set of default configuration
#
# == Parameters:
#
# == Sample usage:
#
# include tomcat::profile::default
#
class tomcat::profile::default {
  case $tomcat::version_real {
    '6': {
      tomcat::listener { 'org.apache.catalina.core.JasperListener': }
      tomcat::listener { 'org.apache.catalina.core.JreMemoryLeakPreventionListener': }
      tomcat::listener { 'org.apache.catalina.mbeans.ServerLifecycleListener': }
      tomcat::listener { 'org.apache.catalina.mbeans.GlobalResourcesLifecycleListener': }
    }
    '7': {
      tomcat::listener { 'org.apache.catalina.security.SecurityListener': }
      tomcat::listener { 'org.apache.catalina.core.JasperListener': }
      tomcat::listener { 'org.apache.catalina.mbeans.GlobalResourcesLifecycleListener': }
      tomcat::listener { 'org.apache.catalina.core.ThreadLocalLeakPreventionListener': }
    }
    default: {}
  }
}