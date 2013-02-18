require 'spec_helper'

describe 'tomcat' do

  describe 'default_include_lucid' do

    let (:facts) { {
      :lsbdistcodename  => 'lucid',
      :operatingsystem  => 'Ubuntu',
      :concat_basedir   => '/var/lib/puppet/concat'
    } }
   
    # package 
    it do should contain_package('tomcat/packages').with(
      'ensure'  => 'present',
      'name'    => [ 'tomcat6', 'tomcat6-common', 'libtomcat6-java' ],
      'before'  => 'Service[tomcat/service]'
    ) end

    # service
    it do should contain_service('tomcat/service').with(
      'ensure'  => 'running',
      'enable'  => true,
      'name'    => 'tomcat6',
      'require' => 'Package[tomcat/packages]'
    ) end

    it { should contain_class('tomcat::debian') }

    # configs
    it do should contain_file('tomcat/configdir').with(
      'ensure'  => 'directory',
      'path'    => '/etc/tomcat6',
      'owner'   => 'root',
      'group'   => 'tomcat6',
      'mode'    => '0750'
    ) end

    it do should contain_concat('/etc/tomcat6/tomcat-users.xml').with(
      'owner'   => 'root',
      'group'   => 'tomcat6',
      'mode'    => '0640',
      'require' => 'Package[tomcat/packages]',
      'notify'  => 'Service[tomcat/service]'
    ) end

    it do should contain_concat('/etc/tomcat6/server.xml').with(
      'owner'   => 'root',
      'group'   => 'tomcat6',
      'mode'    => '0640',
      'require' => 'Package[tomcat/packages]',
      'notify'  => 'Service[tomcat/service]'
    ) end

  end

end
