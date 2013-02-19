require 'spec_helper'

describe 'tomcat::connector' do

  let (:facts) { {
    :lsbdistcodename  => 'lucid',
    :operatingsystem  => 'Ubuntu',
    :concat_basedir   => '/var/lib/puppet/concat'
  } }

  let (:pre_condition) do
    'class tomcat { $tomcat_server_xml = "/etc/whatever" }'
  end

  context 'with parameters' do
    let (:name) { '8080' }
    let (:title) { '8080' }
    let (:params) { { :parameters => {
      'port'      => '8080',
      'protocol'  => 'HTTP/1.1'
    } } }
    it do
      should contain_concat__fragment('20_connector_8080').with_content(/<Connector port="8080" protocol="HTTP\/1\.1" \/>\n/)
    end
  end

  context 'with non hash parameter' do
    let (:name) { '8080' }
    let (:title) { '8080' }
    let (:params) { { :parameters => 'not_a_hash' } }
    it do
      expect {
        should contain_concat__fragment('20_connector_8080')
      }.to raise_error(Puppet::Error, /"not_a_hash" is not a Hash/)
    end
  end 

end
