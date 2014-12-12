#Create the directories where ssl keys are stored
directory node["cassandra"]["dse"]["cassandra_ssl_dir"] do
  owner node["cassandra"]["user"]
  group node["cassandra"]["group"]
  mode '0700'
  recursive true
end

#Generate a local password to use for the keystore and write it to a file
bash "generate keystore password" do
  user node["cassandra"]["user"]
  code <<-EOH
  openssl rand -base64 32 > #{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["cassandra"]["dse"]["password_file"]}
  chmod 600 #{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["cassandra"]["dse"]["password_file"]}
  EOH
  not_if do
    File.exists?("#{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["cassandra"]["dse"]["password_file"]}")
  end
end

#Generate a certificate to use for cassandra
bash "generate cassandra cert" do
  user node["cassandra"]["user"]
  code <<-EOH
  pass=$(head -n 1 #{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["cassandra"]["dse"]["password_file"]})
  keytool -genkey -v -keyalg RSA -keysize 1024 -alias #{node["hostname"]} -keystore #{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["hostname"]}.keystore -storepass $pass -dname 'CN=ODS' -keypass $pass -validity 3650
  EOH
  not_if do
    File.exists?("#{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["hostname"]}.keystore")
  end
end

#Figure out the public key of the cert and export it
bash "export public key" do
  user node["cassandra"]["user"]
  code <<-EOH
  pass=$(head -n 1 #{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["cassandra"]["dse"]["password_file"]})
  keytool -export -alias #{node["hostname"]} -file #{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["hostname"]}.cer -keystore #{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["hostname"]}.keystore
  EOH
  not_if do
    File.exists?("#{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["hostname"]}.cer")
  end
end

#TODO this section needs work and does not fully work.
#Check to see if the attribute has already been set
#if !node.attribute?("cassandra_public_key")
#  node.default["cassandra_public_key"] = lazy { `openssl x509 -inform der -in #{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["hostname"]}.cer -pubkey -noout` }
#end

#TODO put logic here to import all public keys to the keystore
#Import the hostname and attribute (will I have to output the attribute as a file?)
#cookbook = run_context.cookbook_collection[cookbook_name].metadata.name
#ssl_search = partial_search(:node, "chef_environment:#{node.chef_environment} AND recipe:#{cookbook}*", :keys => {'name' => ['hostname'], 'pub_key' => ["cassandra_public_key"]})

#ssl_search.each_pair do |name,pub_key|
  bash "import public keys" do
    user node["cassandra"]["user"]
    code <<-EOH
    pass=$(head -n 1 #{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["cassandra"]["dse"]["password_file"]})
    keytool -import -v -trustcacerts -alias #{node["hostname"]} -file #{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["hostname"]}.cer -keystore #{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["hostname"]}.truststore -storepass $pass -noprompt && echo "true" > #{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["hostname"]}.imported
    EOH
    not_if do
      File.exists?("#{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["hostname"]}.imported")
    end
  end
#end
