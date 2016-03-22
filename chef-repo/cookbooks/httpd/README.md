
### httpdをインストールする
- attributesを使う(変数)
- definitionsを使う(関数化)
- recipes
   -  パッケージインストール
   -  eRubyを使ってconfを設定
   -  サービス起動

#### attributes
**default.rb (/chef-repo/cookbooks/httpd/attributes)**
```
default['yum']['package1'] = "httpd"
```

#### definitions
**httpd_install.rb (/chef-repo/cookbooks/httpd/definitions)**
```
define :httpd_install do
   yum_package "#{node['yum']['package1']}" do
      action :install
   end
end
```

#### template
**chef-repo/cookbooks/httpd/templates/default**
```
NameVirtualHost *:8000
<VirtualHost *:8000>
        ServerName <%= @hostname %>
        DocumentRoot /var/www/test
        ErrorLog logs/test-error_log
        CustomLog logs/test-access_log common
</VirtualHost>
```

#### recipes
**default.rb (/chef-repo/cookbooks/httpd/recipes)**
-  definitionで定義したものを書く
```
httpd_install
```

-  configファイルをテンプレートを利用して設定
```
template "/etc/httpd/conf.d/mysite.conf" do
  source "mysite.conf.erb"
  owner	 "root"
  group  "root"
  mode   0644
  action :create
  variables({
	:hostname => `/bin/hostname`.chomp
  })
end
```
- サービス起動
```
service "httpd" do
  action :start
end
```


httpd Cookbook
==============
TODO: Enter the cookbook description here.

e.g.
This cookbook makes your favorite breakfast sandwich.

Requirements
------------
TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

e.g.
#### packages
- `toaster` - httpd needs toaster to brown your bagel.

Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### httpd::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['httpd']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### httpd::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `httpd` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[httpd]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
