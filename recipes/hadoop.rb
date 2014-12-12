node.default['cassandra']['hadoop'] = true
#Hadoop should not use vnodes
node.default['cassandra']['num_tokens'] = '1'

#hadoop likes to scan
node.default['cassandra']['range_request_timeout_in_ms'] = "30000"

include_recipe "cassandra::default"

#set up the mapred template so we can do some config
template "#{node['cassandra']['dse']['conf_dir']}/hadoop/mapred-site.xml" do
  source "hadoop/mapred-site.xml.erb"
  notifies :restart, "service[#{node['cassandra']['dse']['service_name']}]"
  owner node['cassandra']['user']
  group node['cassandra']['group']
end

#set up hive-site so we can config
template "/etc/dse/hive/hive-site.xml" do
  source "hadoop/hive-site.xml.erb"
  notifies :restart, "service[#{node['cassandra']['dse']['service_name']}]"
  owner node['cassandra']['user']
  group node['cassandra']['group']
end

#create the separate mapred dir
directory node['hadoop']['map_red_localdir'] do
  owner node['cassandra']['user']
  group node['cassandra']['group']
  mode "755"
  recursive true
  action :create
end

#create separate scratch dir (We dont want /tmp)
directory node['hive']['scratch_dir'] do
  owner node['cassandra']['user']
  group node['cassandra']['group']
  mode "755"
  recursive true
  action :create
end
