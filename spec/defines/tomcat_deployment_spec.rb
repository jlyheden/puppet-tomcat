require 'spec_helper'

describe 'tomcat::deployment' do

  let (:facts) { {
    :lsbdistcodename  => 'lucid',
    :operatingsystem  => 'Ubuntu',
    :concat_basedir   => '/var/lib/puppet/concat'
  } }

  let (:pre_condition) do [
    'class {"tomcat": }',
  ]
  end

  context 'deploy application with defaults' do
    let (:name) { 'test_app' }
    let (:title) { 'test_app' }
    it do
      should contain_file('tomcat_deployment_descriptor_test_app').with_content(/<!-- MANAGED BY PUPPET -->\n<Context docBase="\/usr\/share\/tomcat6\/test_app" path="test_app">\n<\/Context>\n/)
    end
  end

end
