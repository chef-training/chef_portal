module PortalHelpers

  def convert_node_object_to_export_of_node(node)
    { :name => node['name'],
      :ipaddress => node['ec2']['public_ipv4'],
      :platform => node['platform']
    }
  end

  def student_tag(student_prefix,student_id)
    "#{student_prefix}-#{student_id}"
  end

  def workstations_for_student(student_tag)
    search('class_machines', "tags:workstation AND tags:#{student_tag}").map do |w_node|
      convert_node_object_to_export_of_node(w_node)
    end
  end

  def nodes_for_student(student_tag)
    search('class_machines', "tags:node-? AND tags:#{student_tag}").map do |n_node|
      convert_node_object_to_export_of_node(n_node)
    end
  end

  def find_machines
    student = node['chef_classroom']['student_prefix']
    count = node['chef_classroom']['number_of_students']
    1.upto(count).map do |i|
      current_student_tag = student_tag(student,i)
      { :name => "#{student}-#{i}",
        :workstations => workstations_for_student(current_student_tag),
        :nodes => nodes_for_student(current_student_tag) }
    end
  end

  def find_chefserver
    search('node', 'tags:chefserver').map do |s_node|
      convert_node_object_to_export_of_node(s_node)
    end
  end

 def current_node_export
    {
      :class_name => node['chef_classroom']['class_name'],
      :console_address => "http://#{node['ec2']['public_ipv4']}:8080/guacamole",
      :key => "/root/.ssh/#{node['chef_classroom']['class_name']}-portal_key",
      :students => find_machines,
      :chefserver => find_chefserver
    }
  end

end

Chef::Resource::Template.include PortalHelpers
