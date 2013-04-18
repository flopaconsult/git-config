define(:git_config,
  :action                 => [:create],                             # 
  :user                   => "root",                                #
  :user_dir               => "/root",                               #
  :git_key                => "id_git",                              #
  :databag                => 'git',                                 #
  :databag_key            => 'github'                               #
  ) do

  user             = params[:user]
  key_dir          = "#{params[:user_dir]}/.ssh"
  key              = params[:git_key]
  databag          = params[:databag]
  databag_key      = params[:databag_key]
  ssh_wrapper_path = "#{params[:user_dir]}/#{node['git-config']['ssh_wrapper']}"
  node.set['git-config']['ssh_wrapper_path'] = ssh_wrapper_path
  node.save

  package "git-core" if (platform?("ubuntu") && node.platform_version.to_f >= 10.04) 

  directory key_dir do
    owner user
    group user
    mode "0700"
    action :create
  end
  
  #app = Chef::EncryptedDataBagItem.load(node['git-config']['databag'], node['git-config']['databag_key'])
  app = Chef::DataBagItem.load(databag, databag_key)

  file "#{key_dir}/#{key}" do
    content app['deploy_key']
    owner user
    group user
    mode 0600
  end

  template ssh_wrapper_path do
    source "wrap-ssh4git.sh.erb"
    cookbook "git-config" #this is required because of this is called from another cookbook the calling cookbook will be searched for the template
    owner user
    group user
    mode 0700
    variables(
      :key => "#{key_dir}/#{key}"
    )
  end

end
