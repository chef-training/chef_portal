require 'spec_helper'
require './libraries/node_export'
require 'yaml'

describe PortalHelpers do

  class Test
    class Recipe
      include PortalHelpers

      def node
        { 'chef_classroom' => {
            'class_name' => 'CLASS_NAME',
            'number_of_students' => 1,
            'student_prefix' => 'student'
          },
          'ec2' => { 'public_ipv4' => 'localhost' } }
      end
    end
  end

  let(:target_nodes_file) do
    YAML.load(File.read('./spec/fixtures/nodes.yml'))
  end

  let(:first_student_data) do
    target_nodes_file[:students].find { |i| i[:name] == 'student-1' }
  end

  describe '#current_node_export' do

    let(:expected_results) do
      target_nodes_file
    end

    let(:found_machines) do
      [ { name: 'student-1',
        workstations: [ name: "workstation-1", ipaddress: "192.168.0.2", platform: "centos" ],
        nodes: [
         { name: "node-1",
           ipaddress: "192.168.0.3",
           platform: "centos" },
        { name: "node-2",
          ipaddress: "192.168.0.4",
          platform: "centos" },
        { name: "node-3",
          ipaddress: "192.168.0.5",
          platform: "windows" }
        ]
      } ]
    end

    let(:found_chefserver) do
      [ { name: "CLASS_NAME-chefserver",
          ipaddress: "192.168.100.1",
          platform: "centos" } ]
    end


    it 'generates the correct hash' do
      recipe = Test::Recipe.new
      allow(recipe).to receive(:find_machines).and_return(found_machines)
      allow(recipe).to receive(:find_chefserver).and_return(found_chefserver)
      expect(recipe.current_node_export).to eq(expected_results)
    end
  end

  describe '#find_chefserver' do

    let(:expected_results) do
      target_nodes_file[:chefserver]
    end

    let(:search_results) do
      [{ 'name' => 'CLASS_NAME-chefserver',
        'ec2' => { 'public_ipv4' => '192.168.100.1' },
        'platform' => 'centos' }]
    end

    it 'generates the correct array of chef servers' do
      recipe = Test::Recipe.new
      allow(recipe).to receive(:search).with('node','tags:chefserver').and_return(search_results)
      expect(recipe.find_chefserver).to eq(expected_results)
    end

  end


  describe '#workstations_for_student' do
    let(:workstation_search_results) do
      [{
        'name' => 'workstation-1',
        'ec2' => { 'public_ipv4' => '192.168.0.2' },
        'platform' => 'centos',
      }]
    end

    let(:expected_results) do
      first_student_data[:workstations]
    end

    it 'returns the correct formatted array of content' do
      recipe = Test::Recipe.new
      allow(recipe).to receive(:search).and_return(workstation_search_results)
      expect(recipe.workstations_for_student('student-1')).to eq(expected_results)
    end

  end

  describe '#nodes_for_students' do
    let(:nodes_search_results) do
      [{
        'name' => 'node-1',
        'ec2' => { 'public_ipv4' => '192.168.0.3' },
        'platform' => 'centos',
      },
      {
        'name' => 'node-2',
        'ec2' => { 'public_ipv4' => '192.168.0.4' },
        'platform' => 'centos',
      },
      {
        'name' => 'node-3',
        'ec2' => { 'public_ipv4' => '192.168.0.5' },
        'platform' => 'windows',
      }
    ]
    end

    let(:expected_results) do
      first_student_data[:nodes]
    end

    it 'returns the correct formatted array of content' do
      recipe = Test::Recipe.new
      allow(recipe).to receive(:search).and_return(nodes_search_results)
      expect(recipe.nodes_for_student('student-1')).to eq(expected_results)
    end

  end

  describe '#find_machines' do

    let(:expected_results) do
      [ { name: 'student-1',
          workstations: [],
          nodes: [] } ]
    end

    it 'generates the correct array of machines' do
      recipe = Test::Recipe.new

      allow(recipe).to receive(:workstations_for_student).and_return([])
      allow(recipe).to receive(:nodes_for_student).and_return([])
      expect(recipe.find_machines).to eq(expected_results)
    end
  end
end
