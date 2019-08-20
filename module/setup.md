# Setup your own Chef Org

### Step 0
Go to ```http://chef.automate.demo.com```

### Step 1
On the Chef Server, go to the ```Administartion Tab``` and click on ```Create```

### Step 2
Create an Org with your name
![Org](/images/org.png)

### Step 3
Download the ```Starter Kit``` for your Org
![StarterKit](/images/starterkit.png)

### Step 4
Unzip the Starter Kit and place the ```Chef-Repo``` directory in C:>Users -> <YourName> 

### Step 5
Check the SSL Cert with the command ```knife ssl check``` and you will get a failure
![ssl](/images/sslcheck.png)

### Step 6
Add the ```trusted_certs_dir    "#{ENV['HOME']}/.chef/trusted_certs"``` to the ```C:\Users\<YourName>\chef-repo\.chef\knife.rb```
![knife](/images/knife.png)
