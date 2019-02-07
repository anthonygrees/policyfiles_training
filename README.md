# Chef Policyfiles Training Lab
![Policyfile](/images/policyfile.png)
## About
A training lab on how to use Chef Policyfiles

Policies are built by defining a Policyfile, which looks similar to a Chef Role combined with a Berksfile. 

When a Policy is ready for upload, a workstation command included with the ChefDK compiles the Policyfile into a ```Policyfile.lock``` file. This locked Policy, along with all of the cookbooks it references, are treated as a single unit by the Chef tooling. The bundle of ```Policyfile.lock``` and cookbooks are uploaded to the server simultaneously. 

## Why use Policyfiles ?
Policyfiles provide cookbook dependency management and replaces roles and environments. This allows you to get exact, repeatable results !

Policies make your chef-client runs completely repeatable, because cookbooks referenced in a Policy are identified by a unique hash based on their contents. This means that once the lock file + cookbook bundle has been generated, the code underlying it will never change.

Policyfiles ensure all dependent cookbooks are pinned, all role attributes are saved and it is all versioned, testable and ready for your pipeline.

If you are familuar with Chef Server roles, runlists and environments, then:
- ```policy_name```  = role/runlist 
- ```policy_group``` = environment

## How do you use a Policyfile ?
The best way to use ```policyfiles``` is with in a pipeline.  Here is a Jenkins example to give you some ideas, but you can see much more detail in this repo - https://github.com/anthonygrees/chef_pipelines

![Cookbook Pipeline](https://github.com/anthonygrees/chef_pipelines/blob/master/images/policyfile_pipeline.png)

## Training Lab
This training lab is a hands on set of code examples to show you how ```policyfiles``` work.  It covers how to create and modify, plus using ```policy_groups``` and exporting them as tarballs.

Let's write some code.

- Module 1 - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/part_a.md">Create a Policyfile</a>
- Module 2 - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/part_b.md">Modify a Policyfile</a>
- Module 3 - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/part_c.md">How Policyfiles can inherit other policyfiles</a>
- Module 4 - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/part_d.md">Apply Policy Groups to a Node</a>
- Module 5 - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/part_e.md">Using attributes with Policy Group</a>
- Module 6 - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/part_f.md">Exporting Policyfiles and using Archives</a>
- Module 7 - <a href="https://github.com/anthonygrees/policyfiles_training/blob/master/module/part_z.md">Tips and Tricks</a>

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
