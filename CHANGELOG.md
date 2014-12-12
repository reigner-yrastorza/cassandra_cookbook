# CHANGELOG for dse cookbook

This file is used to list changes made in each version of the dse cookbook.
## 3.1.0
* Updated to be environment aware, automatically add nodes that belong to the same environment

## 3.0.12
* refactored some version checks
* added role based seed assignment

## 3.0.11
* add templates and upgrade to 4.5.2 

## 3.0.10
* add templates and upgrade to 4.0.4 

## 3.0.9
* remove the ssd tuning from this recipe 

## 3.0.8
* minor updates

## 3.0.7
* adding ability to tune memtable thresholds

## 3.0.6
* removed specific tuning to move it to os-tuning cookbook
* adding ability to set concurrent compactors

## 3.0.5
* added thrift frame size settings for hadoop requests

## 3.0.4

*adding recommended datastax tuning settings

## 3.0.3

* adding cassandra specific gc settings

## 3.0.2

* more hadoop tunung

## 3.0.1

* adding hadoop tuning settings

## 3.0.0

* First pass of node-to-node ssl 
* Adding another hadoop attribute
* fixing hadoop map reduce dir, as hadoop didnt create
* adding changes to ssl
* adding a version-specific dse script
* adding support to stop dse before an upgrade
* hive scratch directory support

## 2.3.5

* subscribed the dse service to java, so it will restart if java version changes
* added more chefspec
* moved the start of the dse service until after all the templates are set up

## 2.3.4

* allow support for gossipingPropertyFileSnitch

## 2.3.3

* Tell the OS that SSDs are present

## 2.3.2

* Allow Solr and Hadoop Heap to be set dynamically

## 2.3.1

* Allows this recipe to install the datastax-agent

## 2.3.0

* Allow DSE 4.0 to be installed

## 2.2.0

* Rename the cookbook to dse

## 2.1.3

* Added kitchen tests
* Added multiple data directory support

## 0.1.0:

* Initial release of cassandra

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
