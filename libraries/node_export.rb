def node_export

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

  {
    :class_name => node['chef_classroom']['class_name'],
    :console_address => "http://#{node['ec2']['public_ipv4']}:8080/guacamole",
    :key => "/root/.ssh/#{node['chef_classroom']['class_name']}-portal_key",
    :workstations => workstation_nodes,
    :nodes => additional_nodes,
    :chefserver => chefserver_nodes
  }
end
