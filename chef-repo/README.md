chef-server側のレシピの追加
==========
```
【chef-server側でレシピを作成】
#wget --no-check-certificate -O ./chef-repo.tar.gz http://github.com/opscode/chef-repo/tarball/master
#tar xvfz chef-repo.tar.gz
#mv chef-chef-repo-e3efb8c chef-repo

【chef-clientのファイルを設定するために環境変数を設定】
# export EDITOR=vim

# knife cookbook create httpd -o /root/chef-repo/cookbooks
→ cookbookを追加
** Creating cookbook httpd in /root/chef-repo/cookbooks
** Creating README for cookbook: httpd
** Creating CHANGELOG for cookbook: httpd
** Creating metadata for cookbook: httpd

【レシピの作成】
#pwd
/root/chef-repo/cookbooks/httpd/recipes
#cat default.rb

package "httpd" do
action :install
end

【httpdをインストールするレシピをアップロード】
# knife cookbook upload httpd -o /root/chef-repo/cookbooks
Uploading httpd [0.1.0]
Uploaded 1 cookbook.

【chef-clientに実行させるレシピを追加】
# knife node run_list add test-httpd.cs93cloud.internal 'recipe[httpd]'
test-httpd.cs93cloud.internal:

node側でchef-clientと打てばインストールがされる。
```

Deprecated
==========

Use of this repository is deprecated. We recommend using the `chef generate repo` command that comes with [ChefDK](http://downloads.chef.io/chef-dk/).

Overview
========

Every Chef installation needs a Chef Repository. This is the place where cookbooks, roles, config files and other artifacts for managing systems with Chef will live. We strongly recommend storing this repository in a version control system such as Git and treat it like source code.

While we prefer Git, and make this repository available via GitHub, you are welcome to download a tar or zip archive and use your favorite version control system to manage the code.

Repository Directories
======================

This repository contains several directories, and each directory contains a README file that describes what it is for in greater detail, and how to use it for managing your systems with Chef.

* `cookbooks/` - Cookbooks you download or create.
* `data_bags/` - Store data bags and items in .json in the repository.
* `roles/` - Store roles in .rb or .json in the repository.
* `environments/` - Store environments in .rb or .json in the repository.

Configuration
=============

The repository contains a knife configuration file.

* .chef/knife.rb

The knife configuration file `.chef/knife.rb` is a repository specific configuration file for knife. If you're using Hosted Chef, you can download one for your organization from the management console. If you're using the Open Source Chef Server, you can generate a new one with `knife configure`. For more information about configuring Knife, see the Knife documentation.

https://docs.chef.io/knife.html

Next Steps
==========

Read the README file in each of the subdirectories for more information about what goes in those directories.
