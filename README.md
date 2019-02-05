# Policyfiles Training Lab
A training lab on how to use Chef Policyfiles

Policies are built by defining a Policyfile, which looks similar to a Chef Role combined with a Berksfile. 

When a Policy is ready for upload, a workstation command included with the ChefDK compiles the Policyfile into a ```Policyfile.lock``` file. This locked Policy, along with all of the cookbooks it references, are treated as a single unit by the Chef tooling. The bundle of ```Policyfile.lock``` and cookbooks are uploaded to the server simultaneously. 
## Why Policyfiles ?
Policyfiles provide cookbook dependency management and replaces roles and environments. This allows you to get exact, repeatable results !

Policies make your chef-client runs completely repeatable, because cookbooks referenced in a Policy are identified by a unique hash based on their contents. This means that once the lock file + cookbook bundle has been generated, the code underlying it will never change.

## Step 1: Create a base policyfile
The base policyfile will be used by all the nodes.

```
# Policyfile.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://github.com/opscode/chef-dk/blob/master/POLICYFILE_README.md

# A name that describes what the system you're building with Chef does.
name 'base'

# Where to find external cookbooks:
default_source :supermarket

cookbook 'chef-client', git: 'https://github.com/anthonygrees/chef-client.git'
cookbook 'audit_agr', git: 'https://github.com/anthonygrees/audit_agr.git'

# run_list: chef-client will run these recipes in the order specified.
run_list 'audit_agr', 'chef-client'

override['chef_client']['interval'] = 1800
override['chef_client']['splay'] = 100

# https://docs.chef.io/data_collection_without_server.html
override['chef_client']['config']['data_collector.server_url'] = 'https://ndnd/data-collector/v0/'
override['chef_client']['config']['data_collector.token'] = '8ZzgdoqAPRWsW4XOHRiFx7Kbobk='
override['chef_client']['config']['data_collector.organization'] = 'home'
override['audit']['reporter'] = 'chef-automate'
override['audit']['interval']['enabled'] = true
override['audit']['interval']['time'] = 180 # 8 times a day

override['audit']['profiles']['linux-patch-baseline'] = { 'url': 'https://github.com/dev-sec/linux-patch-baseline/archive/0.4.0.zip' }
```
