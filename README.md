# Policyfiles Training Lab
## About
A training lab on how to use Chef Policyfiles

Policies are built by defining a Policyfile, which looks similar to a Chef Role combined with a Berksfile. 

When a Policy is ready for upload, a workstation command included with the ChefDK compiles the Policyfile into a ```Policyfile.lock``` file. This locked Policy, along with all of the cookbooks it references, are treated as a single unit by the Chef tooling. The bundle of ```Policyfile.lock``` and cookbooks are uploaded to the server simultaneously. 

## Why use Policyfiles ?
Policyfiles provide cookbook dependency management and replaces roles and environments. This allows you to get exact, repeatable results !

Policies make your chef-client runs completely repeatable, because cookbooks referenced in a Policy are identified by a unique hash based on their contents. This means that once the lock file + cookbook bundle has been generated, the code underlying it will never change.

Policyfiles ensure all dependent cookbooks are pinned, all role attributes are saved and it is all versioned, testable and ready for your pipeline.

If you are familuar with Chef Server roles, runlists and environments, then:
- ```policy_name```  = role/runlist 
- ```policy_group``` = environment

# Part A: CREATE a Base Policyfile
## Step 1: Create a base policyfile
The base policyfile will be used by all the nodes.

Run the following command in the directory ```C:\Users\chef\cookbooks\policies>```. If the directory does not exist, create it:
```
$ chef generate policyfile base
```

Your output will look like this:
```
C:\Users\chef\cookbooks\policyfiles> chef generate policyfile base
Recipe: code_generator::policyfile
  * template[C:/Users/chef/cookbooks/policyfiles/base.rb] action create
    - create new file C:/Users/chef/cookbooks/policyfiles/base.rb
    - update content in file C:/Users/chef/cookbooks/policyfiles/base.rb from none to 533141
    (diff output suppressed by config)
C:\Users\chef\cookbooks\policyfiles>
```

Now edit the file
```
$ code base.rb
```

In Visual Studio Code, create the following:

```
# base.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://github.com/opscode/chef-dk/blob/master/POLICYFILE_README.md

# A name that describes what the system you're building with Chef does.
name 'base'

# Where to find external cookbooks:
default_source :supermarket

# Specify a custom source for a cookbook:
cookbook 'chef-client', git: 'https://github.com/anthonygrees/chef-client.git'
cookbook 'audit_agr', git: 'https://github.com/anthonygrees/audit_agr.git'

# run_list: chef-client will run these recipes in the order specified.
run_list 'audit_agr', 'chef-client'

```

The cookbook source could be from public supermarket, private supermarket, a chef server, a local repo or even an artifact repo.
Here are some examples:
```
default_source :supermarket  # Public Supermarket
default_source :supermarket, "https://mysupermarket.example"  # Private Supermarkey
default_source :chef_server, "https://chef-server.example/organizations/example"
default_source :chef_repo, "path/to/repo" 
default_source :artifactory, "https://artifactory.example/api/chef/my-supermarket
```

## Step 2: Generate the ```lock``` file
With our basic base.rb policyfile, we run ```chef install`` to fetch dependencies and generate a ```base.lock.json```.

So run the following command:
```
$ chef install base.rb
```
and you will see the following output
```
C:\Users\chef\cookbooks\policyfiles> chef install base.rb
Building policy base
Expanded run list: recipe[audit_agr], recipe[chef-client]
Caching Cookbooks...
Installing chef-client >= 0.0.0 from git
Installing audit_agr   >= 0.0.0 from git
Installing cron        6.2.1
Installing logrotate   2.2.0
Installing windows     5.2.3
Installing audit       7.3.0

Lockfile written to C:/Users/chef/cookbooks/policyfiles/base.lock.json
Policy revision id: f458a363e1ed148676a5ee5c9a558cb0dd3ba8581803de44de49ccd7b1d5e134
C:\Users\chef\cookbooks\policyfiles>
```

## Step 3: Let's take a look at the lock file
Let’s take a look at the base.lock.json we just created. We’ll go over each part individually:

Run the collowing command:
```
$ code .
```
This will show us the ```base.lock.json``` file

### Revision ID
Each time we create or update the lock, chef will automatically generate a revision_id based on the content. These values are used to automatically version your policies, so that you can apply different revsions of a policy to different set of servers. We’ll see this in action a little later.
```
"revision_id": "5f750bf464100b487cd7c276c5d532341b79fbeb5e8accd29538ae972896992b"
```

### Name and Run List
The lock includes the name and run list we specified previously. The run list is normalized to the least ambiguous form.

In this example, you will see that it has selected the ```default``` recipe for both of the cookbooks.
```
"run_list": [
    "recipe[audit_agr::default]",
    "recipe[chef-client::default]"
```

### Cookbook Locks
For each cookbook we use, there is a corresponding entry in the ```cookbook_locks``` section. The exact data collected about each cookbook is dependent on the cookbook’s source. In this case, we have a cookbook sourced from GitHub which is a git repo. In the event we need to debug this cookbook later, ChefDK has collected information about the cookbook’s git revision. 

You will notice that it has included more cookbooks than we specified.  This is because the ```Audit``` and ```Chef_Client``` cookbooks have dependant cookbooks.  The policyfile tracks each and every one !

```
  "cookbook_locks": {
    "audit": {
      "version": "7.3.0",
      "identifier": "ec19259446ed7259f898861c30d1b106d649616f",
      "dotted_decimal_identifier": "66455743695875442.25324606895960273.194642923053423",
      "cache_key": "audit-7.3.0-supermarket.chef.io",
      "origin": "https://supermarket.chef.io:443/api/v1/cookbooks/audit/versions/7.3.0/download",
      "source_options": {
        "artifactserver": "https://supermarket.chef.io:443/api/v1/cookbooks/audit/versions/7.3.0/download",
        "version": "7.3.0"
      }
    },
    "audit_agr": {
      "version": "2.2.2",
      "identifier": "997012b6a9e2488cfead390e2fdf26821a3cf3cf",
      "dotted_decimal_identifier": "43188897113039432.39686516679520223.42340227806159",
      "cache_key": "audit_agr-de245088a67ed9a178e39ad33b9868d95c0a20df",
      "origin": "https://github.com/anthonygrees/audit_agr.git",
      "source_options": {
        "git": "https://github.com/anthonygrees/audit_agr.git",
        "revision": "de245088a67ed9a178e39ad33b9868d95c0a20df"
      }
    },
    "chef-client": {
      "version": "10.2.2",
      "identifier": "665de50495d89d717cd73c0cf68a15a847a621d8",
      "dotted_decimal_identifier": "28813685830310045.31943936235599498.23812500759000",
      "cache_key": "chef-client-65efbdbc8d8df7077378974a07455be06699708d",
      "origin": "https://github.com/anthonygrees/chef-client.git",
      "source_options": {
        "git": "https://github.com/anthonygrees/chef-client.git",
        "revision": "65efbdbc8d8df7077378974a07455be06699708d"
      }
    },
    "cron": {
      "version": "6.2.1",
      "identifier": "08676b5cc33658430ce04cecc16dd07200380e83",
      "dotted_decimal_identifier": "2365510629144152.18872980942405997.229188048522883",
      "cache_key": "cron-6.2.1-supermarket.chef.io",
      "origin": "https://supermarket.chef.io:443/api/v1/cookbooks/cron/versions/6.2.1/download",
      "source_options": {
        "artifactserver": "https://supermarket.chef.io:443/api/v1/cookbooks/cron/versions/6.2.1/download",
        "version": "6.2.1"
      }
    },
    "logrotate": {
      "version": "2.2.0",
      "identifier": "53e09234a4f73cc13f46d833d2e5075cafddfaa8",
      "dotted_decimal_identifier": "23609341620057916.54394244012692197.8094668946088",
      "cache_key": "logrotate-2.2.0-supermarket.chef.io",
      "origin": "https://supermarket.chef.io:443/api/v1/cookbooks/logrotate/versions/2.2.0/download",
      "source_options": {
        "artifactserver": "https://supermarket.chef.io:443/api/v1/cookbooks/logrotate/versions/2.2.0/download",
        "version": "2.2.0"
      }
    },
    "windows": {
      "version": "5.2.3",
      "identifier": "b9450a2483840dd3f3e9044b17eb8c5c2fec3178",
      "dotted_decimal_identifier": "52148780556059661.59659402210908139.154327568888184",
      "cache_key": "windows-5.2.3-supermarket.chef.io",
      "origin": "https://supermarket.chef.io:443/api/v1/cookbooks/windows/versions/5.2.3/download",
      "source_options": {
        "artifactserver": "https://supermarket.chef.io:443/api/v1/cookbooks/windows/versions/5.2.3/download",
        "version": "5.2.3"
      }
    }
  },
```

### Attributes
Policyfiles can have attributes that replace role attributes. We’ll see these a little later.
```
"default_attributes": {

  },
  "override_attributes": {

  },
```

### Solution Dependencies
You can ignore the ```solution_dependencies``` section. It’s used to keep track of dependencies in your cookbooks so ChefDK can check whether changes to your cookbooks are compatible with their dependencies without having to download the full cookbook list from supermarket every time.
```
"default_attributes": {

  },
  "override_attributes": {

  },
```

## Step 4: Upload the policyfile to the Chef Server
To do this we need to understand about ```policy_group```s.  A policy group is essentially an environment and allows you to assign multiple nodes to the group of policies.

### Promote to the Development Policy Group
Let's upload the policyfile to the Chef Server and add it to the Policy Group of ```dev_dc1`` for development in Data Center 1.

To do this, we use the chef push subcommand to upload an existing Policyfile.lock.json file to the Chef server, along with all of the cookbooks that are contained in the file. The ```base.lock.json``` file will be applied to the specified policy group, which is a set of nodes that share the same run-list and cookbooks.
```
$ chef push dev_dc1 base.rb
```

Your output will look something like this:
```
C:\Users\chef\cookbooks\policyfiles> chef push dev_dc1 base.rb
Uploading policy to policy group dev_dc1
Uploaded audit       7.3.0  (ec192594)
Uploaded audit_agr   2.2.2  (997012b6)
Uploaded chef-client 10.2.2 (665de504)
Uploaded cron        6.2.1  (08676b5c)
Uploaded logrotate   2.2.0  (53e09234)
Uploaded windows     5.2.3  (b9450a24)
C:\Users\chef\cookbooks\policyfiles>
```

### Promote to the System Test Policy Group
Your testing in ```dev_dc1`` has passed.  Let's promote to policy group ```sys_dc1```.
```
$ chef push sys_dc1 base.rb
```

### Promote to the Production Test Policy Group
Your testing in ```sys_dc1`` has passed.  Let's promote to policy group ```prod_dc1```.
```
$ chef push prod_dc1 base.rb
```

### How do you know which Policy is on a Chef Server ?
Use the ```chef show-policy``` subcommand to display revisions for every base.rb file that is on the Chef server. By default, only active policy revisions are shown. When both a policy and policy group are specified, the contents of the active ```base.lock.json``` file for the policy group is returned.

```
$ chef show-policy base
```
Each policy in each policy group is the same. Your output will look something like this:
```
C:\Users\chef\cookbooks\policies> chef show-policy
base
====

* dev_dc1:   aa65b40c43
* prod_dc1:  aa65b40c43
* sys_dc1:   aa65b40c43

C:\Users\chef\cookbooks\policies>
```

### Compare with ```chef diff```
Use the ```chef diff``` subcommand to display an itemized comparison of two revisions of a ```Policyfile.lock.json``` file.

Run the following command to see the difference between Development DC1 and Production DC1
```
$ chef diff .\base.lock.json dev_dc1...prod_dc1
```
Your output will look something like this.  There are no changes to display:
```
C:\Users\chef\cookbooks\policies> chef diff .\base.lock.json dev_dc1...prod_dc1
No changes for policy lock 'base' between 'policy_group:dev_dc1' and 'policy_group:prod_dc1'
C:\Users\chef\cookbooks\policies>
```

# Part B: Now lets MODIFY the Base Policyfile
## Step 1: Update the attributes via policyfile
Policyfiles allow us to set attributes. Since Policyfiles don’t support roles, these attributes replace role attributes in the precedence hierarchy. In our ```base.rb``` policyfile, we set attributes using the same syntax we use in cookbooks. 

Add the following lines to the bottom of your ```base.rb``` policyfile:
```
# Override the Chef Client cookbook with the following attributes
override['chef_client']['interval']    = '200'
override['chef_client']['splay']       = '30'
```

## Step 2: Update the ```policyfile``` lock file
Now run the ```chef update``` command to to apply the changes to the ```base.loc.json```:
```
$ chef update base.rb
```

Your output will look something like this:
```
C:\Users\chef\cookbooks\policyfiles> chef update base.rb
Updated attributes in C:/Users/chef/cookbooks/policyfiles/base.lock.json
Building policy base
Expanded run list: recipe[audit_agr], recipe[chef-client]
Caching Cookbooks...
Installing chef-client >= 0.0.0 from git
Installing audit_agr   >= 0.0.0 from git
Using      cron        6.2.1
Using      logrotate   2.2.0
Using      windows     5.2.3
Using      audit       7.3.0

Lockfile written to C:/Users/chef/cookbooks/policyfiles/base.lock.json
Policy revision id: 6e7735d685d3a602c7b97ae2eedaf30b126f7820a83a56abe1457aec5643d3a5
C:\Users\chef\cookbooks\policyfiles>
```

## Step 3: Take another look at the lockfile again
We have updated the attributes for the ```chef_client``` and used an override.  We will see this in the ```base.lock.json``` under the ```default_attributes``` section.
You can see that we have overridden the ```interval``` and the ```splay```.
```
"default_attributes": {

  },
  "override_attributes": {
    "chef_client": {
      "interval": "200",
      "splay": "30"
    }
  },
```

## Step 4: Promote to the Development Policy Group
Let's upload the policyfile to the Chef Server and add it to the Policy Group of ```dev_dc1`` for development in Data Center 1.

```
$ chef push dev_dc1 base.rb
```

Your output will look something like this:
```
C:\Users\chef\cookbooks\policies> chef push dev_dc1 base.rb
Uploading policy to policy group dev_dc1
Using    audit       7.3.0  (ec192594)
Using    audit_agr   2.2.2  (997012b6)
Using    chef-client 10.2.2 (665de504)
Using    cron        6.2.1  (08676b5c)
Using    logrotate   2.2.0  (53e09234)
Using    windows     5.2.3  (b9450a24)
C:\Users\chef\cookbooks\policies>
```

## Step 5: Compare changes in Development to System Test and Production
How do we know what changes are where ????

### Check the Policy
Run the ```chef show-policy``` command
```
$ chef show-policy base
```
Development is different to System Test and Production. Your output will look something like this:
```
C:\Users\chef\cookbooks\policies> chef show-policy base
base
====

* dev_dc1:   6e7735d685
* prod_dc1:  f458a363e1
* sys_dc1:   f458a363e1

C:\Users\chef\cookbooks\policies>
```

### Compare with ```chef diff```
Use the ```chef diff``` subcommand to display an itemized comparison of two revisions of a ```Policyfile.lock.json``` file.

Run the following command to see the difference between Development DC1 and Production DC1
```
$ chef diff .\base.lock.json dev_dc1...prod_dc1
```
Your output will look something like this.  ALL the changes are now displayed:
```
C:\Users\chef\cookbooks\policies> chef diff .\base.lock.json dev_dc1...prod_dc1
Policy lock 'base' differs between 'policy_group:dev_dc1' and 'policy_group:prod_dc1':

REVISION ID CHANGED
===================

@@ -1,2 +1,2 @@
-6e7735d685d3a602c7b97ae2eedaf30b126f7820a83a56abe1457aec5643d3a5
+f458a363e1ed148676a5ee5c9a558cb0dd3ba8581803de44de49ccd7b1d5e134

OVERRIDE ATTRIBUTES CHANGED
===========================

@@ -1,7 +1,4 @@
 {
-  "chef_client": {
-    "interval": "200",
-    "splay": "30"
-  }
+
 }

C:\Users\chef\cookbooks\policies>
```

# Part C: Policyfiles can inherit other Policyfiles !
We can use our base policyfile in other policyfiles.  Let's create a enterprise policyfile now.

## Step 1: CREATE a new ```policyfile``` called enterprise
Run the following command:
```
$ chef generate policyfile enterprise
```

Your output will look like this:
```
C:\Users\chef\cookbooks\policies> chef generate policyfile enterprise
Recipe: code_generator::policyfile
  * template[C:/Users/chef/cookbooks/policies/enterprise.rb] action create
    - create new file C:/Users/chef/cookbooks/policies/enterprise.rb
    - update content in file C:/Users/chef/cookbooks/policies/enterprise.rb from none to 928395
    (diff output suppressed by config)
C:\Users\chef\cookbooks\policies>
```

## Step 2: Edit the enterprise.rb file
Now edit the file
```
$ code enterprise.rb
```

In Visual Studio Code, create the following:

```
# Policyfile.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'enterprise'

include_policy 'base', path: './base.lock.json'

# Where to find external cookbooks:
default_source :supermarket

# Specify a custom source for a single cookbook:
# cookbook 'example_cookbook', path: '../cookbooks/example_cookbook'
cookbook 'ntp', '~> 3.6.2'

# run_list: chef-client will run these recipes in the order specified.
run_list 'ntp'

# Override the Chef Client cookbook with the following attributes
override['audit']['profiles']['linux-patch-baseline'] = { 'url': 'https://github.com/dev-sec/linux-patch-baseline/archive/0.4.0.zip' }

```

Now install the policy file
```
$ chef install enterprise.rb
```

You will see the following output
```
C:\Users\chef\cookbooks\policies> chef install enterprise.rb
Building policy enterprise
Expanded run list: recipe[audit_agr::default], recipe[chef-client::default], recipe[ntp]
Caching Cookbooks...
Using      audit_agr   2.2.2
Using      chef-client 10.2.2
Using      ntp         3.6.2
Using      audit       7.3.0
Using      cron        6.2.1
Using      logrotate   2.2.0
Using      windows     5.2.3

Lockfile written to C:/Users/chef/cookbooks/policies/enterprise.lock.json
Policy revision id: 2c0e98fbaf62f59066821d20b31ad92e11869b71092e7af02174f647fd84a546
C:\Users\chef\cookbooks\policies>
```

## Step 3: Take a look at the ```enterprise.lock.json```
You will notice that there is a section called ```included_policy_locks``` that has the ```include``` for our base.rb

```
"included_policy_locks": [
    {
      "name": "base",
      "revision_id": "6e7735d685d3a602c7b97ae2eedaf30b126f7820a83a56abe1457aec5643d3a5",
      "source_options": {
        "path": "./base.lock.json"
      }
    }
  ],
  ```
  
## Step 4: Promote to the Development Policy Group
Let's upload the policyfile to the Chef Server and add it to the Policy Group of ```dev_dc1`` for development in Data Center 1.

```
$ chef push dev_dc1 enterprise.rb
```

Your output will look something like this:
```
C:\Users\chef\cookbooks\policies> chef push dev_dc1 enterprise.rb
Uploading policy to policy group dev_dc1
Using    audit       7.3.0  (ec192594)
Using    audit_agr   2.2.2  (997012b6)
Using    chef-client 10.2.2 (665de504)
Using    cron        6.2.1  (08676b5c)
Using    logrotate   2.2.0  (53e09234)
Using    ntp         3.6.2  (7ac2f7ed)
Using    windows     5.2.3  (b9450a24)
C:\Users\chef\cookbooks\policies>
```

## Step 5: Check the Policy

### First, let's check the ```enterprise policyfile```
Run the ```chef show-policy``` command
```
$ chef show-policy enterprise
```
Your output will look something like this:
```
C:\Users\chef\cookbooks\policies> chef show-policy enterprise
enterprise
=========

* dev_dc1:   2c0e98fbaf
* prod_dc1:  *NOT APPLIED*
* sys_dc1:   *NOT APPLIED*

C:\Users\chef\cookbooks\policies>
```

### Now, let's check both the ```base``` and ```enterprise policyfiles```
Run the ```chef show-policy``` command
```
$ chef show-policy
```
Your output will look something like this:
```
C:\Users\chef\cookbooks\policies> chef show-policy
base
====

* dev_dc1:   6e7735d685
* prod_dc1:  f458a363e1
* sys_dc1:   f458a363e1

enterprise
=========

* dev_dc1:   2c0e98fbaf
* prod_dc1:  *NOT APPLIED*
* sys_dc1:   *NOT APPLIED*

C:\Users\chef\cookbooks\policies>
```

# Part D: Apply ```Policy_Groups``` to a Node
Let's assign the policies to Nodes

## Step 1: What nodes do we have available ?
Start by checking what nodes are being managed by the Chef Server.

Run the following command:
```
$ knife node list
```

Your output will look something like this:
```
C:\Users\chef\cookbooks\policies> knife node list
dev1
dev2
prod1
prod2
prod3
stage1
stage2
C:\Users\chef\cookbooks\policies>
```

## Step 2: Assign the ```dev1``` node to the ```enterprise``` policy and the ```dev_dc1``` policy group
Run the following command:
```
$ knife node policy set dev1 dev_dc1 enterprise
```

Your output will look something like this:
```
C:\Users\chef\cookbooks\policies> knife node policy set dev1 dev_dc1 enterprise
Successfully set the policy on node dev1
C:\Users\chef\cookbooks\policies>
```

## Step 3: Check the policy group is assigned to the node
Run the following command:
```
$ knife node show dev1
```

Your output will look something like this:
```
C:\Users\chef\cookbooks\policies> knife node show dev1
Node Name:   dev1
Policy Name:  enterprise
Policy Group: dev_dc1
FQDN:        delivered.automate-demo.com
IP:          18.237.142.79
Run List:
Recipes:
Platform:    ubuntu 14.04
Tags:
C:\Users\chef\cookbooks\policies>
```

# Part E: Using attributes to dynamically change based on ```Policy_group```

A ```cookbook``` can use a ```case``` statement in the ```cookbook/attributes/default.rb``` to dynamically override an attribute based on the ```policy_group``` the node is assigned.
```
case node.policy_group
when 'prod_dc1'
 default['ntp']['servers'] = [
  'ntp0.prod.acme.internal',
  'ntp1.prod.acme.internal'
 ]
when 'dev_dc1', 'sys_dc1'
 default['ntp']['servers'] = [
  'ntp0.dev.acme.internal',
  'ntp1.dev.acme.internal'
 ]
else
 default['ntp']['servers'] = ['0.pool.ntp.org', '0.pool.ntp.org']
end
```

# Part F: Export a Policyfile
Use the chef export subcommand to create a chef-zero-compatible chef-repo that contains the cookbooks described by a Policyfile.lock.json file. After a chef-zero-compatible chef-repo is copied to a node, the policy can be applied locally on that machine by running chef-client -z (local mode).

Run the command to export as a tarball:
```
chef export base.rb c:\Users\chef\cookbooks --archive
```

You will see the following output:
```
C:\Users\chef\cookbooks\policies> chef export base.rb c:\Users\chef\cookbooks --archive
Exported policy 'base' to c:/Users/chef/cookbooks/base-6e7735d685d3a602c7b97ae2eedaf30b126f7820a83a56abe1457aec5643d3a5.tgz
C:\Users\chef\cookbooks\policies>
```


# NOTE: Be careful of the following
The following is a list of areas to be careful of when using ```policyfiles```

## Where to find your cookbooks
If you have multiple sources and a cookbook with the same name in both sources, Chef won't know which source to choose.
```
# Where to find external cookbooks:
default_source :supermarket
default_source :chef_server
```
If a run-list or any dependencies require a cookbook that is present in more than one source, be explicit about which source is preferred. This will ensure that a cookbook is always pulled from an expected source. 
```
default_source :supermarket, "https://supermarket.example" do |s|
  s.preferred_for "chef-client", "nginx", "mysql"
end
default_source :chef_server
```
