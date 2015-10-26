# Cookbook Name:: chef_portal
# Recipe:: fundamentals_3x

include_recipe 'chef_portal::provisioner_node'

class_dir = node['chef_portal']['chef_classroom']['dir']

# Clone the classroom git repo
execute 'berks_vendor_cookbooks' do
  action :nothing
  command 'berks vendor cookbooks'
  cwd class_dir
end

git class_dir do
  repository node['chef_portal']['chef_classroom']['repo']
  revision node['chef_portal']['chef_classroom']['master']
  action :sync
  notifies :run, 'execute[berks_vendor_cookbooks]', :immediately
end

# This is a hack, this dir should be created in chef_classroom repo
directory "#{class_dir}/roles"

# Setup the web portal interface for fundamentals_3x
include_recipe 'chef_portal::_fundamentals_3x_webapp'

# Now go deploy infrastructure like a fucking wizard
# chef-client -z -r 'recipe[chef_classroom::deploy_workstations]'
# chef-client -z -r 'recipe[chef_classroom::deploy_server]'
# chef-client -z -r 'recipe[chef_classroom::deploy_first_nodes]'
# chef-client -z -r 'recipe[chef_classroom::deploy_multi_nodes]'
