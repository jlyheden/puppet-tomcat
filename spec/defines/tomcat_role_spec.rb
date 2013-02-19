require 'spec_helper'

describe 'tomcat::role' do

  let (:facts) { {
    :lsbdistcodename  => 'lucid',
    :operatingsystem  => 'Ubuntu',
    :concat_basedir   => '/var/lib/puppet/concat'
  } }

  context 'role' do
    let (:name) { 'admin' }
    let (:title) { 'admin' }
    it do
      should contain_concat__fragment('20_tomcat_users_xml_admin').with_content(/^<role rolename="admin"\/>\n$/)
    end
  end

  context 'empty role name' do
    let (:name) { '' }
    let (:title) { '' }
    it do
      expect {
        should contain_concat__fragment('20_tomcat_users_xml_')
      }.to raise_error(Puppet::Error,/Namevar must not be empty/)
    end
  end

end
