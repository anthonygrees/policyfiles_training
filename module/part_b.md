### Part B: Now lets MODIFY the Base Policyfile
#### Step 1: Update the attributes via policyfile
Policyfiles allow us to set attributes. Since Policyfiles don’t support roles, these attributes replace role attributes in the precedence hierarchy. In our ```base.rb``` policyfile, we set attributes using the same syntax we use in cookbooks.

Add the following lines to the bottom of your ```base.rb``` policyfile:
```
# Override the Chef Client cookbook with the following attributes
override['chef_client']['interval']    = '200'
override['chef_client']['splay']       = '30'
```

#### Step 2: Update the ```policyfile``` lock file
Now run the ```chef update``` command to to apply the changes to the ```base.lock.json```:
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

#### Step 3: Take another look at the lockfile again
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

#### Step 4: Promote to the Development Policy Group
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

#### Step 5: Compare changes in Development to System Test and Production
How do we know which changes are where????

##### Check the Policy
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

##### Compare with ```chef diff```
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
