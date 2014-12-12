#Cassandra SSL Options
default['cassandra']['dse']['cassandra_ssl_dir']     = "/etc/cassandra"
default['cassandra']['dse']['password_file']         = "cassandra_pass.txt"
default['cassandra']['dse']['internode_encryption']  = "none"
default['cassandra']['dse']['keystore']              = "#{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["hostname"]}.keystore"
default['cassandra']['dse']['truststore']            = "#{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["hostname"]}.truststore"
