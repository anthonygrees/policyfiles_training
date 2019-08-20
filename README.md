# Chef Policyfiles Training Lab
![Policyfile](/images/policyfile.png)
## About
A training lab on how to use Chef Policyfiles

Policies are built by defining a Policyfile, which looks similar to a Chef Role combined with a Berksfile.

When a Policy is ready for upload, a workstation command included with the ChefDK compiles the Policyfile into a ```Policyfile.lock.json``` file. This locked Policy, along with all of the cookbooks it references, are treated as a single unit by the Chef tooling. The bundle of ```Policyfile.lock.json``` and cookbooks are uploaded to the server simultaneously.

Policyfiles have a number of clear benefits:
 - They ensure the cookbooks running in production are the same versions that were tested against; providing safer development workflows
 - They solve the Roles and Environments versioning issues
 - They streamline the Roles and Environments patterns and dependency management into a single workflow
 - This reduction of discreet concepts reduces the learning curve for getting started with Chef

## Why use Policyfiles ?
Policyfiles provide cookbook dependency management and replaces Roles and Environments. This allows you to get exact, repeatable results!

Policies make your chef-client runs completely repeatable, because cookbooks referenced in a Policy are identified by a unique hash based on their contents. This means that once the lock file + cookbook bundle has been generated, the code underlying it will never change.

Policyfiles ensure all dependent cookbooks are pinned, all attributes are saved and it is all versioned, testable, and ready for your pipeline.

If you are familuar with Chef Server Roles, run lists and Environments, then:
- ```policy_name```  = role/runlist
- ```policy_group``` = environment

## How do you use a Policyfile ?
The best way to use ```policyfiles``` is within a pipeline.  Here is a Jenkins example to give you some ideas, but you can see much more detail in this repo - https://github.com/anthonygrees/chef_pipelines

![Cookbook Pipeline](https://github.com/anthonygrees/chef_pipelines/blob/master/images/policyfile_pipeline.png)

## Training Lab
This training lab is a hands on set of code examples to show you how ```policyfiles``` work.  It covers how to create and modify, plus using ```policy_groups``` and exporting them as tarballs.

Let's write some code.

- Setup - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/setup.md">Create a Chef Server Org</a>
- Module 1 - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/part_a.md">Create a Policyfile</a>
- Module 2 - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/part_b.md">Modify a Policyfile</a>
- Module 3 - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/part_c.md">How Policyfiles can inherit other policyfiles</a>
- Module 4 - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/part_d.md">Apply Policy Groups to a Node</a>
- Module 5 - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/part_e.md">Using attributes with Policy Group</a>
- Module 6 - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/part_f.md">Exporting Policyfiles and using Archives</a>
- Module 7 - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/part_y.md">How are Policyfiles shown in Chef Automate 2</a>
- Module 8 - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/part_z.md">Tips and Tricks</a>

## Other Policyfiles Resources
 - Blog Post - <a href="https://blog.chef.io/2019/03/05/policyfiles-a-chef-best-practice/">Policyfiles a Chef Best Practice</a>
 - Learn Chef Rally Part 1 - <a href="https://learn.chef.io/modules/getting-started-with-policyfiles#/">Getting started with Policyfiles</a>
 - Learn Chef Rally Part 2 - <a href="https://learn.chef.io/modules/managing-nodes-with-policyfiles#/">Managing Nodes with Policyfiles</a>
 - Video Demo

[![Alt text](https://img.youtube.com/vi/n4rbrYpcuMk/0.jpg)](https://youtu.be/n4rbrYpcuMk)


---
## License and Author

* Author:: Anthony Rees <anthony@chef.io>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
