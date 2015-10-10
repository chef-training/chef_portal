#
# Cookbook Name:: chef_portal
# Recipe:: _fundamentals_3x_webapp
#
# Author:: George Miranda (<gmiranda@chef.io>)
# License:: MIT
# Copyright (c) 2015 Chef Software, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

service 'iptables' do
  action [:disable, :stop]
end

package 'httpd'

file '/etc/httpd/conf.d/welcome.conf' do
  action :delete
  notifies :restart, "service[httpd]"
end

# Write out a new HTTPD configuration that lets routes traffic to localhost:8080
template '/etc/httpd/conf.d/portal_site.conf' do
  source 'portal_site.conf.erb'
  notifies :restart, "service[httpd]"
end

service 'httpd' do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end

#
# Deploy the website
#
git '/root/portal_site' do
  repository 'git://github.com/burtlo/portal_site.git'
  revision 'master'
  action :sync
  # notifies :run, 'execute[berks_vendor_cookbooks]', :immediately
end


workstation_nodes = search('node','tags:workstation').map do |w_node|
  { :ipaddress => w_node['ec2']['public_ipv4'],
    :platform_family => w_node['platform_family'] }
end


additional_nodes = 1.upto(3).map do |workstation_index|
  nodes = search('class_machines',"tags:node#{workstation_index}").map do |n_node|
    { :ipaddress => n_node['ec2']['public_ipv4'],
      :platform_family => n_node['platform_family'] }
  end
  { :label => "node#{workstation_index}", :nodes => nodes }
end

chefserver_nodes = search('node', 'tags:chefserver').map do |s_node|
  { :ipaddress => s_node['ec2']['public_ipv4'],
    :platform_family => s_node['platform_family'] }
end

node_export = {
  :class_name => node['chef_classroom']['class_name'],
  :console_address => "http://#{node['ec2']['public_ipv4']}:8080/guacamole",
  :key => "/root/.ssh/#{node['chef_classroom']['class_name']}-portal_key",
  :workstations => workstation_nodes,
  :nodes => additional_nodes,
  :chefserver => chefserver_nodes
}

template '/root/portal_site/nodes.yml' do
  source 'webapp/nodes.yml.erb'
  mode '0644'
  variables :export => node_export
end

execute 'bundle install' do
  cwd '/root/portal_site'
  environment({
    "GEM_HOME"=>"/root/.chefdk/gem/ruby/2.1.0",
    "GEM_PATH"=>"/root/.chefdk/gem/ruby/2.1.0:/opt/chefdk/embedded/lib/ruby/gems/2.1.0",
    "GEM_ROOT"=>"/opt/chefdk/embedded/lib/ruby/gems/2.1.0",
    "PATH"=> "#{ENV['PATH']}:/opt/chefdk/embedded/bin"
  })
end

execute 'rackup -D -p 8081' do
  cwd '/root/portal_site'
  environment({
    "GEM_HOME"=>"/root/.chefdk/gem/ruby/2.1.0",
    "GEM_PATH"=>"/root/.chefdk/gem/ruby/2.1.0:/opt/chefdk/embedded/lib/ruby/gems/2.1.0",
    "GEM_ROOT"=>"/opt/chefdk/embedded/lib/ruby/gems/2.1.0",
    "PATH"=> "#{ENV['PATH']}:/opt/chefdk/embedded/bin"
  })
end


# lazy create the guacamole user map and monkeypatch it
# search returns nil during compilation
include_recipe 'guacamole'

chef_gem 'chef-rewind'
require 'chef/rewind'

rewind 'template[/etc/guacamole/user-mapping.xml]' do
  variables(
    lazy do
      { :usermap => guacamole_user_map }
    end
  )
end
