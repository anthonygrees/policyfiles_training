name 'anthony'

default_source :supermarket

cookbook 'chef-client', git: 'https://github.com/anthonygrees/chef-client.git'
cookbook 'audit_agr', git: 'https://github.com/anthonygrees/audit_agr.git'
cookbook 'cis-win2012r2-l1-hardening', git: 'https://github.com/anthonygrees/cis-win2012r2-l1-hardening-cookbook.git'

run_list 'chef-client'

# uncomment this to enable audits and remove the above run_list
# run_list 'chef-client', 'audit_agr'

# uncomment this to enable hardening and remove the above run_lists
# run_list 'chef-client', 'audit_agr', 'cis-win2012r2-l1-hardening'
