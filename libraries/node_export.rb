class Chef
  class Recipe
    def find_students
      search('node', "tags:student-?").map do |n_node|
          { :name => n_node['name'],
            :ipaddress => n_node['ec2']['public_ipv4'],
            :platform => n_node['platform'] }
      end
    end

    def find_chefserver
      search('node', 'tags:chefserver').map do |s_node|
        { :name => s_node['name'],
          :ipaddress => s_node['ec2']['public_ipv4'],
          :platform => s_node['platform']
        }
      end
    end
  end
end
