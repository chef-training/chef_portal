# Cookbook Name:: chef_portal
# Recipe:: fundamentals_3x

include_recipe 'chef_portal::provisioner_node'

class_dir = "#{node['chef_portal']['home_dir']}/chef_classroom"

# Clone the classroom git repo
execute 'berks_vendor_cookbooks' do
  action :nothing
  command 'berks vendor cookbooks'
  cwd class_dir
end

git class_dir do
  repository 'git://github.com/chef-training/chef_classroom.git'
  revision 'master'
  action :sync
  notifies :run, 'execute[berks_vendor_cookbooks]', :immediately
end

# Setup the web portal interface for fundamentals_3x
include_recipe 'chef_portal::_fundamentals_3x_webapp'

# Now go deploy infrastructure like a fucking wizard
# chef-client -z -r 'recipe[chef_classroom::deploy_workstations]'
# chef-client -z -r 'recipe[chef_classroom::deploy_server]'
# chef-client -z -r 'recipe[chef_classroom::deploy_first_nodes]'
# chef-client -z -r 'recipe[chef_classroom::deploy_multi_nodes]'
