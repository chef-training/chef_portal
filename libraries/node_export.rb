class Chef
  class Recipe
    def workstation_nodes
      search('node', 'tags:workstation').map do |w_node|
        { :ipaddress => w_node['ec2']['public_ipv4'],
          :platform_family => w_node['platform_family'] }
      end
    end

    def additional_nodes
      1.upto(3).map do |workstation_index|
        nodes = search('class_machines', "tags:node#{workstation_index}").map do |n_node|
          { :ipaddress => n_node['ec2']['public_ipv4'],
            :platform_family => n_node['platform_family'] }
        end
        { :label => "node#{workstation_index}", :nodes => nodes }
      end
    end

    def chefserver_nodes
      search('node', 'tags:chefserver').map do |s_node|
        { :ipaddress => s_node['ec2']['public_ipv4'],
          :platform_family => s_node['platform_family']
        }
      end
    end
  end
end
