source 'https://supermarket.chef.io'

metadata
# cookbook 'chef_classroom', git: 'git://github.com/gmiranda23/chef_classroom.git'
# cookbook 'guacamole', git: 'git://github.com/gmiranda23/guacamole-cookbook.git'

cookbook 'chef_classroom', path: '../chef_classroom'
# NOTE: This needed to be added to make sure the dependencies resolved without
#       error while running `berks install`
cookbook 'chef_workstation', path: '../chef_workstation'
cookbook 'guacamole', git: '../guacamole-cookbook'
