# Part F: Export a Policyfile and use the Archive
Use the ```chef export``` subcommand to create a chef-zero-compatible chef-repo that contains the cookbooks described by a ```Policyfile.lock.json``` file. After a chef-zero-compatible chef-repo is copied to a node, the policy can be applied locally on that machine by running ```chef-client -z``` (local mode).

## Step 1: Export the policyfile
Run the command to export as a tarball:
```
$ chef export base.rb c:\Users\chef\cookbooks --archive
```

You will see the following output:
```
C:\Users\chef\cookbooks\policies> chef export base.rb c:\Users\chef\cookbooks --archive
Exported policy 'base' to c:/Users/chef/cookbooks/base-6e7735d685d3a602c7b97ae2eedaf30b126f7820a83a56abe1457aec5643d3a5.tgz
C:\Users\chef\cookbooks\policies>
```

## Step 2: Push the Archive to a Chef Server
The ```chef push-archive``` subcommand is used to publish a policy archive file to the Chef server. (A policy archive is created using the ```chef export``` subcommand.) The policy archive is assigned to the specified policy group, which is a set of nodes that share the same run-list and cookbooks.

Run the command to push the tarball:
```
$ chef push-archive new_group c:/Users/chef/cookbooks/base-6e7735d685d3a602c7b97ae2eedaf30b126f7820a83a56abe1457aec5643d3a5.tgz
```

You will see the following output:
```
C:\Users\chef\cookbooks\policies> chef push-archive new_group c:/Users/chef/cookbooks/base-6e7735d685d3a602c7b97ae2eedaf30b126f7820a83a56abe1457aec5643d3a5.tgz
Uploading policy to policy group new_group
Using    audit       7.3.0  (ec192594)
Using    audit_agr   2.2.2  (997012b6)
Using    chef-client 10.2.2 (665de504)
Using    cron        6.2.1  (08676b5c)
Using    logrotate   2.2.0  (53e09234)
Using    windows     5.2.3  (b9450a24)
C:\Users\chef\cookbooks\policies>
```

## Step 3: Check the Policy Groups
Run the following command:
```
$ chef show-policy
```

Your output will look something like this.  Notice the new policy_group ```new_group``` and it matches the policyfile in ```dev_dc1```:
```
C:\Users\chef\cookbooks\policies> chef show-policy
base
====

* new_group:  6e7735d685
* sys_dc1:    f458a363e1
* dev_dc1:    6e7735d685
* prod_dc1:   f458a363e1

enterprise
==========

* new_group:  *NOT APPLIED*
* sys_dc1:    *NOT APPLIED*
* dev_dc1:    59c914e9e7
* prod_dc1:   *NOT APPLIED*

C:\Users\chef\cookbooks\policies>
```
