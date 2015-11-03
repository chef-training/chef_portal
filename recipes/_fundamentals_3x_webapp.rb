# Cookbook Name:: chef_portal
# Recipe:: _fundamentals_3x_webapp

httpd_service 'default' do
  modules ['rewrite', 'proxy', 'proxy_http', 'authz_host']
  action [:create, :start]
end

httpd_config 'default' do
  source 'portal_site.conf.erb'
  notifies :restart, 'httpd_service[default]'
  action :create
end

node.default['selinux']['booleans'] = { 'httpd_can_network_connect' => 'on'}
include_recipe 'selinux'

# Deploy the website
git node['chef_portal']['root_dir'] do
  repository 'git://github.com/chef-training/portal_site.git'
  revision 'master'
  action :sync
end

include_recipe 'chef_portal::_refresh_nodes'

execute 'bundle install' do
  cwd node['chef_portal']['root_dir']
  environment node['chef_portal']['chefdk']['env_vars']
end

include_recipe 'runit'

runit_service "chef-portal" do
  default_logger true
  env node['chef_portal']['chefdk']['env_vars']
end

# lazy create the guacamole user map and monkeypatch it
# search returns nil during compilation
# include_recipe 'guacamole'
#
# chef_gem 'chef-rewind'
# # This FAILS with ChefSpec
# require 'chef/rewind'
#
# rewind 'template[/etc/guacamole/user-mapping.xml]' do
#   variables(
#     lazy do
#       { :usermap => guacamole_user_map }
#     end
#   )
# end
