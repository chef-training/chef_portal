default['chef_portal']['user'] = 'root' # sudo picks up ec2-metadata
default['chef_portal']['password'] = 'chefportal'
default['chef_portal']['root_dir'] = '/root/portal_site'

default['chef_portal']['chefdk']['version'] = '0.8.1'

default['chef_portal']['chefdk']['env_vars'].tap do |env_vars|
  env_vars['GEM_HOME'] = '/root/.chefdk/gem/ruby/2.1.0'
  env_vars['GEM_PATH'] = '/root/.chefdk/gem/ruby/2.1.0:/opt/chefdk/embedded/lib/ruby/gems/2.1.0'
  env_vars['GEM_ROOT'] = '/opt/chefdk/embedded/lib/ruby/gems/2.1.0'
  env_vars['PATH'] = "#{ENV['PATH']}:/opt/chefdk/embedded/bin"
end

default['chef_portal']['chefdk']['gems'].tap do |gems|
  gems['chef-provisioning-aws'] = '1.5.1'
end

default['chef_portal']['pkgs'] = %w(git)

default['chef_portal']['chef_classroom']['repo'] = 'git://github.com/chef-training/chef_classroom.git'
default['chef_portal']['chef_classroom']['branch'] = 'master'
default['chef_portal']['chef_classroom']['dir'] = '/root/chef_classroom'
