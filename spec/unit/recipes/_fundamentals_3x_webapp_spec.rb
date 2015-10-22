require 'spec_helper'

describe 'chef_portal::_fundamentals_3x_webapp' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    before do
      allow_any_instance_of(Chef::Recipe).to receive(:node_export).and_return({})
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'disables iptables'
    it 'enables http can network connect'
    it 'installs the apache package'
    it 'removes the initial apache configuration'
    it 'places a new configuration file that forwards to the port'
    it 'starts the apache server'
    it 'clones the portal site'
    it 'writes out the current node details a configuration file'
    it 'installs the portal site\'s dependencies'
    it 'starts the portl site service'
    it 'loads the guacamole recipe'
    it 'replaces the guacamole user mappings'

  end
end
