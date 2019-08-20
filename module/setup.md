# Setup your own Chef Org

### Step 0 - Log in the the Chef Server
Go to ```http://chef.automate.demo.com```

### Step 1 - Go to the Admin Function
On the Chef Server, go to the ```Administration Tab``` and click on ```Create```

### Step 2 - Create your Org
Create an Org with your name
![Org](/images/org.png)

### Step 3 - Get your starter kit
Download the ```Starter Kit``` for your Org
![StarterKit](/images/starterkit.png)

### Step 4 - Put the Starter Kit where you can find it
Unzip the Starter Kit and place the ```Chef-Repo``` directory in C:>Users -> <YourName> 

### Step 5 - Check the SSL Certs
Check the SSL Cert with the command ```knife ssl check``` and you will get a failure
![ssl](/images/sslcheck.png)

### Step 6 - Trust the Cert
Add the ```trusted_certs_dir    "#{ENV['HOME']}/.chef/trusted_certs"``` to the ```C:\Users\<YourName>\chef-repo\.chef\knife.rb```
![knife](/images/knife.png)

### Step 7 - Check the SSL Certs Again
heck the SSL Cert with the command ```knife ssl check```
