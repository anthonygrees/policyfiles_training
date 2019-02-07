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
