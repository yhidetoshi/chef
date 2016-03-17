### Ruby2.3 wornning message
```
[root@wordpress chef-repo]# chef-solo -c config.rb -j ./test.json
Starting Chef Client, version 12.8.1
Installing Cookbook Gems:
Compiling Cookbooks...
Thread.exclusive is deprecated, use Mutex
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/dsl/declare_resource.rb:91:in `build_resource'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/dsl/declare_resource.rb:62:in `declare_resource'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/dsl/resources.rb:40:in `execute'
/root/chef-repo/cookbooks/hello/recipes/default.rb:9:in `from_file'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/mixin/from_file.rb:30:in `instance_eval'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/mixin/from_file.rb:30:in `from_file'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/cookbook_version.rb:233:in `load_recipe'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/run_context.rb:332:in `load_recipe'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/run_context/cookbook_compiler.rb:140:in `block in compile_recipes'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/run_context/cookbook_compiler.rb:138:in `each'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/run_context/cookbook_compiler.rb:138:in `compile_recipes'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/run_context/cookbook_compiler.rb:75:in `compile'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/run_context.rb:167:in `load'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/policy_builder/expand_node_object.rb:97:in `setup_run_context'
/root/.rbenv/versions/2.3.0/lib/ruby/2.3.0/forwardable.rb:184:in `setup_run_context'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/client.rb:509:in `setup_run_context'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/client.rb:277:in `run'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/application.rb:270:in `block in fork_chef_client'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/application.rb:258:in `fork'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/application.rb:258:in `fork_chef_client'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/application.rb:223:in `block in run_chef_client'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/local_mode.rb:44:in `with_server_connectivity'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/application.rb:211:in `run_chef_client'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/application/solo.rb:301:in `block in interval_run_chef_client'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/application/solo.rb:290:in `loop'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/application/solo.rb:290:in `interval_run_chef_client'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/application/solo.rb:269:in `run_application'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/lib/chef/application.rb:58:in `run'
/root/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/chef-12.8.1/bin/chef-solo:25:in `<top (required)>'
/root/.rbenv/versions/2.3.0/bin/chef-solo:23:in `load'
/root/.rbenv/versions/2.3.0/bin/chef-solo:23:in `<main>'
Converging 1 resources
Recipe: hello::default
  * execute[ls] action run
    - execute ls

Running handlers:
Running handlers complete
Chef Client finished, 1/1 resources updated in 02 seconds
```
