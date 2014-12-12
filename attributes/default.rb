#Cassandra Default Info
default['cassandra']['cluster_name']           = "Test Cluster"
default['cassandra']['vnodes']                 = true
default['cassandra']['initial_token']          = ""
default['cassandra']['num_tokens']             = "256"
default['cassandra']['solr']		       = false
default['cassandra']['hadoop']                 = false
default['cassandra']['spark']                  = false

default['cassandra']['dse_version']            = "4.5.3-1"

default['cassandra']['user']                   = "cassandra"
default['cassandra']['group']                  = "cassandra"

default['cassandra']['data_dir']               = [ "/data/cassandra" ]
default['cassandra']['log_dir']                = "/var/log/cassandra/"
default['cassandra']['root_dir']               = "/var/lib/cassandra/"
default['cassandra']['commit_dir']             = "/var/lib/cassandra/commitlog"

default['cassandra']['listen_address']         = node['ipaddress']
default['cassandra']['rpc_address']            = node['ipaddress']
default['cassandra']['broadcast_address']      = nil 
default['cassandra']['seeds']                  = node['ipaddress']
default['cassandra']['concurrent_reads']       = 32
default['cassandra']['concurrent_writes']      = 32
default['cassandra']['compaction_thruput']     = 16
default['cassandra']['multithreaded_compaction'] = false
default['cassandra']['in_memory_compaction_limit'] = 64
default['cassandra']['trickle_fsync']		= false
default['cassandra']['range_request_timeout_in_ms'] = "10000"
default['cassandra']['thrift_framed_transport_size_in_mb'] = "15"
default['cassandra']['thrift_max_message_length_in_mb'] = nil
default['cassandra']['concurrent_compactors']     = nil

# Role based search to assign seed nodes.
default['cassandra']['role_based_seeds'] = true
default['cassandra']['seed_role']        = "role:dse-seed"

#GC settings
default['cassandra']['CMSInitiatingOccupancyFraction'] = "65"
default['cassandra']['max_heap_size'] = "8192M"
default['cassandra']['heap_newsize'] = "800M"

default['cassandra']['authentication']         = false
default['cassandra']['authorization']          = false
default['cassandra']['authenticator']          = ""
default['cassandra']['authorizer']             =  ""

default['cassandra']['log_level']				= "INFO"
default['cassandra']['audit_logging']  = false
default['cassandra']['audit_dir'] = "/etc/dse/cassandra"
default['cassandra']['active_categories'] = "ADMIN,AUTH,DDL,DCL"

