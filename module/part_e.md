### Part E: Using attributes to dynamically change based on ```Policy_group```

#### Hoisting of attributes
Most users of Policies rely on "hoisting" to provide group specific attributes. This approach was formalised in the ```poise-hoist``` extension. 
https://github.com/chef/chef-rfc/blob/master/rfc105-attribute-hoist.md 

To hoist an attribute, the user would provide a default attribute structure in their Policyfile similar to:
```
default['staging']['myapp']['title'] = "My Staging App"
default['production']['myapp']['title'] = "My App"
```
and would access the node attribute in their cookbook as:
```
node['myapp']['title']
```

The correct attribute would then be provided based on the policy_group of the node, so with a policy_group of staging the attribute would contain "My Staging App".

#### Attribute case statements
Similar to the example above, you can also leverage a ```case``` statement to dynamically determine attributes in the policyfile.
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

#### Search
To be added
