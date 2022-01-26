# Cookbook:: chef_portal
# Recipe:: _refesh_iam_creds

ohai 'reload_ec2' do
  action :nothing
  plugin 'ec2'
end

directory '/etc/chef/ohai/hints' do
  recursive true
end

%w(ec2 iam).each do |hint|
  file "/etc/chef/ohai/hints/#{hint}.json" do
    notifies :reload, 'ohai[reload_ec2]', :immediately
  end
end

# put my IAM credentials somewhere chef-provisioning can use them
directory "#{node['chef_portal']['home_dir']}/.aws" do
  user node['chef_portal']['user']
  group node['chef_portal']['group']
  mode '0700'
end

ruby_block 'set iam role name' do
  block do
    iam_role_name = node['chef_classroom']['iam_instance_profile'].split('/')[1].tr('-', '_')

    node.run_state['iam_role_name'] = if node['ec2']['iam']['security-credentials'].keys.include?(iam_role_name)
                                        iam_role_name
                                      else
                                        node['ec2']['iam']['security-credentials'].keys.first
                                      end
  end
end

template "#{node['chef_portal']['home_dir']}/.aws/config" do
  source 'aws_config.erb'
  variables(
    lazy do
      {
        access_key: node['ec2']['iam']['security-credentials'][node.run_state['iam_role_name']]['AccessKeyId'],
        secret_access_key: node['ec2']['iam']['security-credentials'][node.run_state['iam_role_name']]['SecretAccessKey'],
      }
    end
  )
  user node['chef_portal']['user']
  group node['chef_portal']['group']
  mode '0600'
end
