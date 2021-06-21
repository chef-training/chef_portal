# Cookbook:: chef_portal
# Recipe:: _fundamentals_3x_webapp

httpd_service 'default' do
  modules %w(rewrite proxy proxy_http authz_host)
  action [:create, :start]
end

httpd_config 'default' do
  source 'portal_site.conf.erb'
  notifies :restart, 'httpd_service[default]'
  action :create
end

# Deploy the website
git "#{node['chef_portal']['home_dir']}/portal_site" do
  repository 'git://github.com/chef-training/portal_site.git'
  revision 'master'
  action :sync
end

include_recipe 'chef_portal::_refresh_nodes'

execute 'bundle install' do
  cwd "#{node['chef_portal']['home_dir']}/portal_site"
  environment node['chef_portal']['chefdk']['env_vars']
end

include_recipe 'runit'

runit_service 'chef-portal' do
  default_logger true
  env node['chef_portal']['chefdk']['env_vars']
end

# lazy create the guacamole user map and monkeypatch it
# search returns nil during compilation
include_recipe 'guacamole'
# This FAILS with ChefSpec

edit_resource 'template[/etc/guacamole/user-mapping.xml]' do
  variables(
    lazy do
      { usermap: guacamole_user_map }
    end
  )
end
