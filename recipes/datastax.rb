#This recipe sets up the yum repos, directories, tuning settings, and installs the dse package.
#Install java
include_recipe "java" if node['dse']['manage_java']


#create the data directories for Cassandra
node['cassandra']['data_dir'].each do |dir|
  directory dir do
    owner node['cassandra']['user']
    group node['cassandra']['group']
    mode "775"
    recursive true
    action :create
  end
end

#Make sure the commit directory exists (in case we changed it from default)
directory node['cassandra']['commit_dir'] do
  owner node['cassandra']['user']
  group node['cassandra']['group']
  mode "755"
  recursive true
  action :create
end

#Set up the datastax repo in yum or apt depending on the OS
case node['platform']
when "ubuntu", "debian"
  include_recipe "apt"
    apt_repository "datastax" do
      uri          node['cassandra']['dse']['debian_repo_url']
      distribution "stable"
      components   ["main"]
      key          "http://debian.datastax.com/debian/repo_key"
      action :add
    end
when "redhat", "centos", "fedora", "amazon", "scientific"
   #We need EPEL
   include_recipe "yum::default"
   include_recipe "yumrepo::epel"
   #Set up datastax repo in yum for rhel
   yum_repository "datastax" do
     description "DataStax Enterprise Repo for Apache Cassandra"
     url node['cassandra']['dse']['rhel_repo_url']
     repo_name "datastax"
     action :add
   end
end

#Check for existing dse version and the version chef wants
#This will stop DSE before doing an upgrade (if we let chef do the upgrade)
if File::exists?("/usr/bin/dse")
  dse_version = Mixlib::ShellOut.new("/usr/bin/dse -v").run_command.stdout.chomp
  puts "DEBUG: #{dse_version} = #{node['cassandra']['dse_version'].split('-')[0]}"
  unless Chef::VersionConstraint.new("= #{node['cassandra']['dse_version'].split('-')[0]}").include?(dse_version)
    execute "nodetool drain" do
      timeout 30
    end

    service node['cassandra']['dse']['service_name'] do
      action :stop
    end
  end
end

#install the dse-full package
case node['platform']
#make sure not to overwrite any conf files on upgrade
when "ubuntu", "debian"
  package "dse-full" do
    version node['cassandra']['dse_version']
    action :install
    options '-o Dpkg::Options::="--force-confold"'
  end
when "redhat", "centos", "fedora", "scientific", "amazon"
  package "dse-full" do
    version node['cassandra']['dse_version']
    action :install
  end
end

#do you want the datastax-agent for opscenter?
include_recipe "cassandra::datastax-agent" if node['datastax-agent']['enabled']
