# Cookbook Name:: chef_portal
# Recipe:: _refesh_iam_creds

current_node_export = {
  :class_name => node['chef_classroom']['class_name'],
  :console_address => "http://#{node['ec2']['public_ipv4']}:8080/guacamole",
  :key => "/root/.ssh/#{node['chef_classroom']['class_name']}-portal_key",
  :workstations => workstation_nodes,
  :nodes => additional_nodes,
  :chefserver => chefserver_nodes
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
