############################################### NOTE ###############################################
# This is a forked from Target's cassandra cookbook, my changes can be seen from CHANGELOG.md      #
####################################################################################################

# Datastax Enterprise Chef Cookbook (Apache Cassandra)
This cookbook installs and configures Datastax Enterprise. More info is here ([DataStax Enterprise](http://www.datastax.com/products/)).

It uses officially released Datastax packages. It can tweak the Cassandra config files, but has no way of adding data or creating keyspaces in Cassandra (yet).

## Usage

This cookbook is designed to be used in conjuction with a wrapper cookbook. Used alone, a single node cluster can be created, but in order to create a multiple node cluster a wrapper is recommended.

Example in a wrapper:

```ruby
node.default['java']['jdk_version'] = "7"
node.default['cassandra']['seeds'] = "192.168.1.1, 192.168.1.2"
node.default['cassandra']['dse_version'] = "4.0.3-1"
node.default['cassandra']['max_heap_size'] = "12G"
node.default['cassandra']['heap_newsize'] = "1200M"

include_recipe "dse::cassandra"
```

##Scope

This cookbook attempts to manage almost all Apache Cassandra configuration settings. It can also create Hadoop and Solr nodes, with less attribute to manage their config.

### Apache Cassandra

This cookbook currently provides

 * Datastax 4.x.x (Datastax Enterprise Edition) via packages.

## Requirements

* Chef 11 or higher

## Supported OS Distributions
Tested on:

* RHEL 6.3, 6.4
* Ubuntu 14.04.1 LTS
* Slight testing done on Ubuntu 12.04 (will require some edits)

## Recipes

The provided recipes are `dse::cassandra`, `dse::solr`, and `dse::hadoop`
* `dse::cassandra` will provision DSE as a cassandra node.
* `dse::solr` will provision DSE with solr enabled.
* `dse::hadoop` will provision DSE with hadoop enabled.

There are also recipes that should not be called directly that are used for configuration.
* `dse::default` sets up the templates
* `dse::datastax` sets up the datastax repos
* `dse::datstax-agent` configures the datastax-agent if needed
* `dse::ssl` (work in progress) sets up SSL keys on all nodes

## Attributes
This cookbook will install DSE Cassandra by default. Other attributes you can set are:

### default.rb

#### overall settings
 * `node["cassandra"]["cluster_name"]` (default: `Test Cluster`): The name of the cluster to provision
 * `node["cassandra"]["vnodes"]` (default: `true`): enable or disable vnodes
 * `node["cassandra"]["intial_token"]` (default: `nil`): the initial token to use. leave blank for vnodes
 * `node["cassandra"]["num_tokens"]` (default: `256`): set the number of tokens to use
 * `node["cassandra"]["solr"]` (default: `false`): enable solr or not
 * `node["cassandra"]["hadoop"]` (default: `false`): enable hadoop or not

 * `node["cassandra"]["dse_version"]` (default: `4.0.3-1`): dse version to install
 * `node["cassandra"]["user"]` (default: `cassandra`): the cassandra user
 * `node["cassandra"]["group"]` (default: `cassandra`): the cassandra group

#### cassandra.yaml settings
 * `node["cassandra"]["listen_address"]` (default: `node['ipaddress']`): the ipaddress to use for listen address
 * `node["cassandra"]["rpc_address"]` (default: `node['ipaddress']`): the ipaddress to use for rpc address
 * `node["cassandra"]["broadcast_address"]` (default: `nil`): the ipaddress to use for broadcast address
 * `node["cassandra"]["seeds"]` (default: `node['ipaddress']`): the ipaddress to use for the seed list
 * `node["cassandra"]["concurrent_reads"]` (default: `32`): concurrent reads setting
 * `node["cassandra"]["concurrent_writes"]` (default: `32`): concurrent writes setting
 * `node["cassandra"]["compaction_thruput"]` (default: `16`): limit the throughput of compactions
 * `node["cassandra"]["multithreaded_compaction"]` (default: `false`): enable or disable multithreaded compaction
 * `node["cassandra"]["in_memory_compaction_limit"]` (default: `64`): size limit for in-memory compactions
 * `node["cassandra"]["trickle_fsync"]` (default: `false`): enable trickle fsync, usually for ssd
 * `node["cassandra"]["range_request_timeout_in_ms"]` (default: `10000`): default timeout on range requests
 * `node["cassandra"]["thrift_framed_transport_size_in_mb"]` (default: `15`): the max size of a thrift frame
 * `node["cassandra"]["thrift_max_message_length_in_mb"]` (default: `nil`): the max message length of a thrift call
 * `node["cassandra"]["concurrent_compactors"]` (default: `nil`): the number of concurrent compactors to allow

#### Role based seed selection
 * `node["cassandra"]["role_based_seeds"]` (default: `false`): set to true to assign seeds based on members of dse-seed role
 * `node['cassandra']['seed_role']` (default: `role:dse-seed`): set to a diffrent role to select seeds

#### gc settings

 * `node["cassandra"]["CMSInitiatingOccupancyFraction"]` (default: `65`): cms occupancy fraction to use for gc
 * `node["cassandra"]["max_heap_size"]` (default: `8192M`): default max heap size for cassandra
 * `node["cassandra"]["heap_newsize"]` (default: `800M`): default new gen size for heap

#### authentication settings
 * `node["cassandra"]["authentication"]` (default: `false`): enable or disable authentication
 * `node["cassandra"]["authorization"]` (default: `false`): enable or disable authorization
 * `node["cassandra"]["authenticator"]` (default: ``): the authenticator to use (eg org.apache.cassandra.auth.AllowAllAuthenticator)
 * `node["cassandra"]["authorizor"]` (default: ``): the authorizor to use (eg org.apache.cassandra.auth.AllowAllAuthorizer)

#### audit logs
 * `node["cassandra"]["log_level"]` (default: `INFO`): the log level for cassandra (or solr/hadoop)
 * `node["cassandra"]["audit_logging"]` (default: `false`): turn on audit logging
 * `node["cassandra"]["audit_dir"]` (default: `/var/log/cassandra`): the directory to put audit logs in
 * `node["cassandra"]["active_categories"]` (default: `ADMIN,AUTH,DDL,DCL`): the categories to audit on

### dse.rb
 * `node["cassandra"]["dse"]["delegated_snitch"]` (default: `org.apache.cassandra.locator.SimpleSnitch`): the snitch to use for dse
 * `node["cassandra"]["dse"]["snitch"]` (default: `com.datastax.bdp.snitch.DseDelegateSnitch`): the snitch to use in dse.yaml
 * `node["cassandra"]["dse"]["service_name"]` (default: `dse`): the name of the service
 * `node["cassandra"]["dse"]["conf_dir"]` (default: `/etc/dse`): the directory of dse config files
 * `node["cassandra"]["dse"]["repo_user"]` (default: ``): the datastax username for the repo
 * `node["cassandra"]["dse"]["repo_pass"]` (default: ``): the datastax password for the repo
 * `node["cassandra"]["dse"]["rhel_repo_url"]` (default: `http://#{node['cassandra']['dse']['repo_user']}:#{node['cassandra']['dse']['repo_pass']}@rpm.datastax.com/enterprise`): the rhel repo
 * `node["cassandra"]["dse"]["debian_repo_url"]` (default: `http://#{node['cassandra']['dse']['repo_user']}:#{node['cassandra']['dse']['repo_pass']}@debian.datastax.com/enterprise`): the debian repo

### hadoop.rb
 * `node["hadoop"]["max_heap_size"]` (default: `10G`): the heap size for hadoop
 * `node["hadoop"]["heap_newsize"]` (default: `800M`): the heap newgen size for hadoop
 * `node["hadoop"]["map_child_java_opts"]` (default: `4G`): the size of the map child java heap
 * `node["hadoop"]["reduce_child_java_opts"]` (default: `4G`): the size of the reduce child java heap
 * `node["hadoop"]["map_red_localdir"]` (default: `/data/mapredlocal`): the directory to use for map/reduce
 * `node["hive"]["scratch_dir"]` (default: `/data/hive`): the directory to use for hive
 * `node["hadoop"]["map_reduce_parallel_copies"]` (default: `20`): the number of map reduce copies
 * `node["hadoop"]["mapred_tasktracker_map_tasks_max"]` (default: `23`): the max number of map tasks
 * `node["hadoop"]["mapred_tasktracker_reduce_tasks_max"]` (default: `12`): the max number of reduce tasks
 * `node["hadoop"]["io_sort_mb"]` (default: `512M`): the size of iosort
 * `node["hadoop"]["io_sort_factor"]` (default: `64`): the iosort factor

### solr.rb
 * `node["solr"]["max_heap_size"]` (default: `14G`): the heap size for solr
 * `node["solr"]["heap_newsize"]` (default: `2400M`): the newgen heap size

### java.rb
These are generic java settings. Datastax recommends oracle java, so override openjdk default and download from a specific location.
 * `node["dse"]["manage_java"]` (default: `true`): whether or not to use the java recipe to manage the java install
 * `node["java"]["install_flavor"]` (default: `oracle`): the flavor of java to install
 * `node["java"]["jdk_version"]` (default: `7`): the version of java to use
 * `node['java']['jdk']['7']['x86_64']['url']` (default: ``): the url to get the java 7 file from

### ssl.rb
This portion is under construction. SSL does not currently 100% work.
 * `node["cassandra"]["dse"]["cassandra_ssl_dir"]` (default: `/etc/cassandra`): the directory to use for pem files
 * `node["cassandra"]["dse"]["password_file"]` (default: `cassandra_pass.txt`): the file to store the keystore pass in
 * `node["cassandra"]["dse"]["internode_encyption"]` (default: `none`): the encyption to use (all, dc, rack)
 * `node["cassandra"]["dse"]["keystore"]` (default: `#{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["hostname"]}.keystore`): keystore name
 * `node["cassandra"]["dse"]["truststore"]` (default: `#{node["cassandra"]["dse"]["cassandra_ssl_dir"]}/#{node["hostname"]}.truststore`): truststore name

### datastax-agent.rb
These attributes are used to conigure the datastax-agent. This is used with Datastax Opscenter.

* `node["datastax-agent"]["enabled"]` (default: `false`): whether to install the datastax agent and configure
* `node["datastax-agent"]["version"]` (default: `4.1.1-1`): the version of the datastax agent to install
* `node["datastax-agent"]["conf_dir"]` (default: `/var/lib/datastax-agent/conf`): where the datastax-agent conf file is
* `node["datastax-agent"]["opscenter_ip"]` (default: `192.168.32.3`): the Opscenter IP to connect to


## Dependencies

* java
* yum
* apt

Datastax recommends to use the Oracle jdk version. You can do this by setting an attribute in your environment or run list.

Currently, Oracle prevents you from downloading the package from their website, put it in Artifactory or something as a workaround.
You can override the java url with an attribute, show below.

## Copyright & License

- Author: Daniel Parker (<daniel.c.parker@target.com>)
- Reviewer: Eric Helgeson (<erichelgeson@gmail.com>)

Released under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).
