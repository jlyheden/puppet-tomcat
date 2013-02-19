require 'spec_helper'

describe 'tomcat::user' do

  let (:facts) { {
    :lsbdistcodename  => 'lucid',
    :operatingsystem  => 'Ubuntu',
    :concat_basedir   => '/var/lib/puppet/concat'
  } }

  let (:pre_condition) do [
    'class {"tomcat": }',
  ]
  end

  context 'empty username' do
    let (:name) { '' }
    let (:title) { '' }
    let (:params) { { :password => 'password', :roles => ['role1'] } }
    it do
      expect {
        should contain_concat__fragment('30_tomcat_users_xml_user')
      }.to raise_error(Puppet::Error, /Namevar must not be empty/)
    end
  end

  context 'user no roles empty array' do
    let (:name) { 'user' }
    let (:title) { 'user' }
    let (:params) { { :password => 'password', :roles => [] } }
    it do
      expect {
        should contain_concat__fragment('30_tomcat_users_xml_user')
      }.to raise_error(Puppet::Error, /Parameter roles must contain at least one element/)
    end
  end

  context 'user with one role' do
    let (:name) { 'user' }
    let (:title) { 'user' }
    let (:params) { { :password => 'password', :roles => [ 'role' ] } }
    it do
      should contain_concat__fragment('30_tomcat_users_xml_user').with_content(
        /^<user username="user" password="password" roles="role"\/>\n$/
        ).with(
          'require' => 'Tomcat::Role[role]'
        )
    end
  end

  context 'user with two roles' do
    let (:name) { 'user' }
    let (:title) { 'user' }
    let (:params) { { :password => 'password', :roles => [ 'role1', 'role2' ] } }
    it do
      should contain_concat__fragment('30_tomcat_users_xml_user').with_content(
        /^<user username="user" password="password" roles="role1,role2"\/>\n$/
        ).with(
          'require' => ['Tomcat::Role[role1]','Tomcat::Role[role2]']
        )
    end
  end

end
