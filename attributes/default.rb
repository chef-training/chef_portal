default['chef_portal']['user'] = 'root' # sudo picks up ec2-metadata
default['chef_portal']['group'] = 'root'
default['chef_portal']['home_dir'] = '/root'
default['chef_portal']['password'] = 'chefportal'

default['chef_portal']['chefdk']['version'] = '0.8.1'

default['chef_portal']['chefdk']['env_vars'].tap do |env_vars|
  env_vars['GEM_HOME'] = "#{node['chef_portal']['home_dir']}/.chefdk/gem/ruby/2.1.0"
  env_vars['GEM_PATH'] = "#{node['chef_portal']['home_dir']}/.chefdk/gem/ruby/2.1.0:/opt/chefdk/embedded/lib/ruby/gems/2.1.0"
  env_vars['GEM_ROOT'] = '/opt/chefdk/embedded/lib/ruby/gems/2.1.0'
  env_vars['PATH'] = "#{ENV['PATH']}:/opt/chefdk/embedded/bin"
end

default['chef_portal']['chefdk']['gems'].tap do |gems|
  gems['chef-provisioning-aws'] = '1.5.1'
end

default['chef_portal']['pkgs'] = %w(git)
