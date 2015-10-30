# Cookbook Name:: chef_portal
# Recipe:: _fundamentals_3x_webapp

portal_dir = node['chef_portal']['root_dir']

service 'iptables' do
  action [:disable, :stop]
end

execute 'setsebool -P httpd_can_network_connect on'

package 'httpd'

file '/etc/httpd/conf.d/welcome.conf' do
  action :delete
  notifies :restart, 'service[httpd]'
end

# Write out a new HTTPD configuration that lets routes traffic to localhost:8080
template '/etc/httpd/conf.d/portal_site.conf' do
  source 'portal_site.conf.erb'
  notifies :restart, 'service[httpd]'
end

service 'httpd' do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end

#
# Deploy the website
#
git portal_dir do
  repository 'git://github.com/chef-training/portal_site.git'
  revision 'master'
  action :sync
end

include_recipe 'chef_portal::_refresh_nodes'

execute 'bundle install' do
  cwd portal_dir
  environment('GEM_HOME' => '/root/.chefdk/gem/ruby/2.1.0',
              'GEM_PATH' => '/root/.chefdk/gem/ruby/2.1.0:/opt/chefdk/embedded/lib/ruby/gems/2.1.0',
              'GEM_ROOT' => '/opt/chefdk/embedded/lib/ruby/gems/2.1.0',
              'PATH' => "#{ENV['PATH']}:/opt/chefdk/embedded/bin")
end

execute 'rackup -D -o 0.0.0.0 -p 8081 -P rack.pid' do
  cwd portal_dir
  environment('GEM_HOME' => '/root/.chefdk/gem/ruby/2.1.0',
              'GEM_PATH' => '/root/.chefdk/gem/ruby/2.1.0:/opt/chefdk/embedded/lib/ruby/gems/2.1.0',
              'GEM_ROOT' => '/opt/chefdk/embedded/lib/ruby/gems/2.1.0',
              'PATH' => "#{ENV['PATH']}:/opt/chefdk/embedded/bin")
  not_if { ::File.exist?("#{portal_dir}/rack.pid") }
end

# lazy create the guacamole user map and monkeypatch it
# search returns nil during compilation
include_recipe 'guacamole'

chef_gem 'chef-rewind'
# This FAILS with ChefSpec
require 'chef/rewind'

rewind 'template[/etc/guacamole/user-mapping.xml]' do
  variables(
    lazy do
      { :usermap => guacamole_user_map }
    end
  )
end
