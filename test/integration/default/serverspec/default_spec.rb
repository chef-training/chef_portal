#
# Cookbook Name:: chef_portal
# Spec:: default
#
# Author:: George Miranda (<gmiranda@chef.io>)
# License:: MIT
# Copyright (c) 2015 Chef Software, Inc.

require 'spec_helper'

describe 'chef_portal::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  it 'does something' do
    skip 'Replace this with meaningful tests'
  end

  describe command('curl localhost') do
    its(:stdout) { should match /List of student machines/ }
  end

  describe file('/root/.aws/config') do
    its(:content) { should match /aws_access_key_id/ }
    its(:content) { should match /aws_secret_access_key_id/ }
  end
end
