# Cookbook Name:: chef_portal
# Recipe:: _refesh_iam_creds

current_node_export = {
  :class_name => node['chef_classroom']['class_name'],
  :console_address => "http://#{node['ec2']['public_ipv4']}:8080/guacamole",
  :key => "/root/.ssh/#{node['chef_classroom']['class_name']}-portal_key",
  :students => find_students,
  :chefserver => find_chefserver
}

template "#{node['chef_portal']['root_dir']}/nodes.yml" do
  source 'webapp/nodes.yml.erb'
  mode '0644'
  variables(
    lazy do
      { :export => current_node_export }
    end
  )
end
