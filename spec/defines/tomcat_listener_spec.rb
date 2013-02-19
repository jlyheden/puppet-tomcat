require 'spec_helper'

describe 'tomcat::listener' do

  let (:facts) { {
    :lsbdistcodename  => 'lucid',
    :operatingsystem  => 'Ubuntu',
    :concat_basedir   => '/var/lib/puppet/concat'
  } }

  context 'without parameters' do
    let (:name) { 'com.my.bogus.listener' }
    let (:title) { 'com.my.bogus.listener' }
    it do
      should contain_concat__fragment('12_listener_com.my.bogus.listener').with_content(/^  <Listener className="com.my.bogus.listener" \/>\n$/)
    end
  end

  context 'with parameters' do
    let (:name) { 'com.my.bogus.listener' }
    let (:title) { 'com.my.bogus.listener' }
    let (:params) { { :parameters => { 'key' => 'value' } } }
    it do
      should contain_concat__fragment('12_listener_com.my.bogus.listener').with_content(/^  <Listener className="com.my.bogus.listener" key="value" \/>\n$/)
    end
  end

  context 'with non hash parameter' do
    let (:name) { 'com.my.bogus.listener' }
    let (:title) { 'com.my.bogus.listener' }
    let (:params) { { :parameters => 'not_a_hash' } }
    it do
      expect {
        should contain_concat__fragment('12_connector_com.my.bogus.listener')
      }.to raise_error(Puppet::Error, /"not_a_hash" is not a Hash/)
    end
  end 

  context 'with empty name' do
    let (:name) { '' }
    let (:title) { '' }
    let (:params) { { :parameters => {} } }
    it do
      expect {
        should contain_concat__fragment('12_connector_')
      }.to raise_error(Puppet::Error, /Namevar must not be empty/)
    end
  end

end
