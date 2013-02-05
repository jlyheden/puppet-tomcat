What is it?
===========

A Puppet module that manages Tomcat

Minimally tested on Lucid with stock Tomcat 6 packages and Tomcat 7 pinned from precise

Dependencies:
-------------

* puppet-concat: https://github.com/ripienaar/puppet-concat
* puppet-stdlib: https://github.com/puppetlabs/puppetlabs-stdlib

Usage:
------

You can install, configure and start the service simply by including the class
<pre>
include tomcat
</pre>

However that would probably not be all that useful unless overriding the parameters via Hiera. The module provides some parameters that can be overriden (see init.pp for specifics).

<pre>
class { 'tomcat':
  version => '7',
  jvm_parameters => [ '-Xmx2G', '-Xms1G' ],
}
tomcat::connector { '8080_connector': 
  parameters => {
    'port'              => 8080,
    'protocol'          => 'HTTP/1.1',
    'connectionTimeout' => 20000,
  }
}
tomcat::listener { 'org.apache.catalina.some.custom.listener': }
</pre>

Some convenience classes exists as well to be included in addition to the base tomcat class
<pre>
include tomcat::profile::default
include tomcat::profile::apr
</pre>

If you prefer to inject a static server.xml config to Tomcat you can do that as well.
<pre>
class { 'tomcat':
  server_xml_source => 'puppet:///modules/mymodule/myserver.xml'
}
</pre>

It also supports altering the tomcat-users.xml file
<pre>
tomcat::role { 'admin': }
tomcat::user { 'myuser': password => 'secret', roles => [ 'admin' ] }
</pre>
