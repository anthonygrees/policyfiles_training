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

