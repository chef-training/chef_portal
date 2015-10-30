# Cookbook Name:: chef_portal
# Recipe:: _refesh_iam_creds

template "#{node['chef_portal']['root_dir']}/nodes.yml" do
  source 'webapp/nodes.yml.erb'
  mode '0644'
  variables(
    lazy do
      { :export => current_node_export }
    end
  )
end
