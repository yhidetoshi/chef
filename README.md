chef-soloを実行するまでに基本的な流れ
==========
```
1. knifeコマンドでcookbooks(料理本)を作成
  -> knife cookbook create <cookbook_name> -o cookbooks
2. /maked_cookbooks_name/recipes/default.rbにレシピを書く
3. 実行を定義するための.jsonを書く
4. 実行するための.rbを書く
5. 実行
 -> # chef-solo -c <実行用_hoge.rb> -j ./<実行用_fuga.json>
```

cookbookでやっていること
- httpd
  - packageインストール
  - template利用
  - attributes利用
  - definitions利用

- yum
 - 外部のyum-repo生成リポジトリ
 - epel.repoを作成

- nginx
 - packageインストール
 
- scripts
 - ディレクトリ作成 

- yum-install
 - 複数の指定パッケージをインストール
 


外部のcookbookを利用する
====
- githubから取得する
```
./cookbooks
git clone https://github.com/chef-cookbooks/yum
```

```
# cat localhost.json
{
	"run_list":[
		"recipe[yum]"
	]
}
```

- git cloneしてきたyumのrecipeを書き換える
```
# cd ./cookbooks/yum/recipes

# cat default.rb
yum_repository 'epel' do
  description 'Extra Packages for Enterprise Linux'
  mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  action :create
end
```


chef-server側のレシピ作成と追加
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
=======
# chef-server/client インストール方法　レシピ など
※ chef-repoはsolo

- packageインストール
 - attributes/definitionsを利用 
- ディレクトリ作成
- templateを使ってconfigファイルを設定
 - httpd.conf

### chef serverの構築手順@CentOS6.7

- 条件
 - /etc/hostsでホスト名の名前解決ができること。
  - # hostname -s
- selinux停止

```
# setenforce 0
# wget https://opscode-omnitruck-release.s3.amazonaws.com/el/6/x86_64/chef-server-11.0.6-1.el6.x86_64.rpm
# rpm -ivh chef-server-11.0.6-1.el6.x86_64.rpm
# chef-server-ctl reconfigure
　→ chef-serverの自動セットアップ
# curl -L https://www.opscode.com/chef/install.sh | bash
　→ knife clientのインストール
# cp /etc/chef-server/admin.pem /etc/chef/
# cp /etc/chef-server/chef-validator.pem /etc/chef/validation.pem
# knife configure -i
→　(knifeの初期セットアップ)下記のように入力してもエラーが発生する。

WARNING: No knife configuration file found
Where should I put the config file? [/root/.chef/knife.rb]
Please enter the chef server URL: [https://host_name:443]
Please enter a name for the new user: [root]
Please enter the existing admin name: [admin]
Please enter the location of the existing admin's private key: [/etc/chef-server/admin.pem] /etc/chef/admin.pem
Please enter the validation clientname: [chef-validator]
Please enter the location of the validation key: [/etc/chef-server/chef-validator.pem] /etc/chef/validation.pem
Please enter the path to a chef repository (or leave blank):
Creating initial API user...
Please enter a password for the new user:
ERROR: SSL Validation failure connecting to host: host_name - SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
ERROR: Could not establish a secure connection to the server.
Use `knife ssl check` to troubleshoot your SSL configuration.
If your Chef Server uses a self-signed certificate, you can use
`knife ssl fetch` to make knife trust the server's certificates.

Original Exception: OpenSSL::SSL::SSLError: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed

※hostname ではだめで
host_name.crt
の.crt前までの名前をhostsファイルに記載する。

# knife ssl fetch
# knife configure -i
Overwrite /root/.chef/knife.rb? (Y/N) Y
Please enter the chef server URL: [https://host_name:443]
Please enter a name for the new user: [root]
Please enter the existing admin name: [admin]
Please enter the location of the existing admin's private key: [/etc/chef-server/admin.pem] /etc/chef-server/admin.pem
Please enter the validation clientname: [chef-validator]
Please enter the location of the validation key: [/etc/chef-server/chef-validator.pem] /etc/chef/validation.pem
Please enter the path to a chef repository (or leave blank):
Creating initial API user...
Please enter a password for the new user:
Created user[root]
Configuration file written to /root/.chef/knife.rb

knifeコマンドが利用できるかの確認。
# knife user list
admin
root

# knife client list
chef-validator
chef-webui
```

### chef-clientのインストール
```

@centOS6.5
ホスト名が名前解決できる事が前提。


【Chef-clientのインストール】
# knife bootstrap <ホスト名> -x root -P xxxxxxx

【chef-server側で追加したレシピを実行】
# chef-client

【httpdがインンストールされているかの確認】
# rpm -qa | grep httpd
httpd-tools-2.2.15-39.el6.centos.x86_64
httpd-2.2.15-39.el6.centos.x86_64
```

### chef勉強メモ
===========
- Recipe:あるべき姿を具体的に記載するスクリプト
 - -> httpdをインストールして編集したhttpd.confを配置する

- Attribute:サーバの役割、状態で変動する値
 - -> パッケージ名(CentOSならhttpd、Ubuntuならapache)

- Template:ファイルを動的に生成するテンプレート
 - -> Attributeの値を埋め込むことができる
 
- Role:webやdb等のノードの役割を定義

- Data_bags:クックブックに含ませたくないユーザやホストのデータを管理

- Environment:環境を分ける. prod,testの様に 
