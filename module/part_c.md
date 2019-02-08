### Part C: Policyfiles can inherit other Policyfiles !
We can use our base policyfile in other policyfiles.  Let's create a enterprise policyfile now.

#### Step 1: CREATE a new ```policyfile``` called enterprise
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

#### Step 2: Edit the enterprise.rb file
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

##### Note: You can also use the ```include_policy```
The addition of a ```include_policy``` directive will allow the following:

```include_policy "base", git: "github.com/myorg/policies.git", path: "foo/bar/baz.lock.json"```

The ```include_policy``` directive will support three sources for policies: git, chef server, and a local path.
- To use a locked policy from a local path:

```include_policy "policy_name", path: "./foo/bar"```
- To use a locked policy from a chef server with a specific revision id:

```include_policy "policy_name", policy_revision_id: "abcdabcdabcd", server: "http://example.com"```

- or if the policy name on the chef server differs from the policyfile:

```include_policy "policy_name", policy_revision_id: "abcdabcdabcd", policy_name: "specific_policy_name", server: "http://example.com"```

When using a chef server as the source, it's also possible to specify a policy group instead of a revision. When doing this, the revision of the included policy at the time the lock is created will become part of the lock data:

```include_policy "policy_name", policy_group: "prod", policy_name: "specific_policy_name", server: "http://example.com"```

To use a locked policy from git:

```include_policy "policy_name", git: "github.com/chef/policy_example", path: "./foo/bar"```

To use a locked policy from git with a specific commit SHA:

```include_policy "policy_name", git: "github.com/chef/policy_example", sha: "abcd1234", path: "./foo/bar"```

You can read about more here - https://github.com/chef/chef-rfc/blob/master/rfc097-policyfile-includes.md  

#### Step 3: Take a look at the ```enterprise.lock.json```
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
  
#### Step 4: Promote to the Development Policy Group
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

#### Step 5: Check the Policy

##### First, let's check the ```enterprise policyfile```
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

##### Now, let's check both the ```base``` and ```enterprise policyfiles```
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
