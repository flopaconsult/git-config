#
# Cookbook Name:: git-config
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

git_config node['git-config']['user'] do
  user         node['git-config']['user']
  user_dir     "#{node['git-config']['user_dir']}"
  git_key      node['git-config']['key']
  databag      node['git-config']['databag']
  databag_key  node['git-config']['databag_key']
  ssh_wrapper_path node['git-config']['ssh_wrapper_path']
end

