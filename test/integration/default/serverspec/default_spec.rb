#
# Cookbook:: chef_portal
# Spec:: default
#
# Author:: George Miranda (<gmiranda@chef.io>)
# License:: MIT
# Copyright:: (c) 2015 Chef Software, Inc.

require 'spec_helper'

describe 'chef_portal::default' do
  describe command('curl localhost') do
    its(:stdout) { should match(%r{<h1>Welcome to chef-portal-test</h1>}) }
    its(:stdout) { should match(%r{<h2>Available Instructor Actions</h2>}) }
    its(:stdout) { should match(%r{<h2>Student machines</h2>}) }
    its(:stdout) { should match(%r{<td>student-1-workstation</td>\n\s+<td>192.168.0.2</td>}) }
    its(:stdout) { should match(%r{<td>student-1-node-1</td>\n\s+<td>192.168.0.3</td>}) }
    its(:stdout) { should match(%r{<td>student-1-node-2</td>\n\s+<td>192.168.0.4</td>}) }
    its(:stdout) { should match(%r{<td>student-1-node-3</td>\n\s+<td>192.168.0.5</td>}) }
    its(:stdout) { should match(%r{<td>chef-portal-test-chefserver</td>\n\s+<td><a href="https://192.168.100.1">\n\s+192.168.100.1</a>}) }
  end

  describe file('/root/.aws/config') do
    its(:content) { should match(/aws_access_key_id/) }
    its(:content) { should match(/aws_secret_access_key_id/) }
  end
end
