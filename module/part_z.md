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
