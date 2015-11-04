# Cookbook Name:: chef_portal
# Recipe:: _refesh_iam_creds

template "#{node['chef_portal']['home_dir']}/portal_site/nodes.yml" do
  source 'webapp/nodes.yml.erb'
  mode '0644'
  variables(
    lazy do
      { :export => current_node_export }
    end
  )
end
