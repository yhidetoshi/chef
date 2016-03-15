# chef install config

### chef serverの構築手順@CentOS6.7

- 条件
・/etc/hostsでホスト名の名前解決ができること。
→　127.0.0.1   chef-server99.cs93cloud.internal　として記載。
 ※.cs93cloud.internalをつけないとchef-clientの
・selinux停止

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
Please enter the chef server URL: [https://chef-server99.cs93cloud.internal:443]
Please enter a name for the new user: [root]
Please enter the existing admin name: [admin]
Please enter the location of the existing admin's private key: [/etc/chef-server/admin.pem] /etc/chef/admin.pem
Please enter the validation clientname: [chef-validator]
Please enter the location of the validation key: [/etc/chef-server/chef-validator.pem] /etc/chef/validation.pem
Please enter the path to a chef repository (or leave blank):
Creating initial API user...
Please enter a password for the new user:
ERROR: SSL Validation failure connecting to host: chef-server99.cs93cloud.internal - SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
ERROR: Could not establish a secure connection to the server.
Use `knife ssl check` to troubleshoot your SSL configuration.
If your Chef Server uses a self-signed certificate, you can use
`knife ssl fetch` to make knife trust the server's certificates.

Original Exception: OpenSSL::SSL::SSLError: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed

※hostname ではだめで
ip-172-31-8-104_ap-northeast-1_compute_internal.crt
の.crt前までの名前をhostsファイルに記載する。


# knife ssl fetch
→　(上記エラーの解決方法) 自動的に事前設定された信頼できる証明書の位置に、証明書をダウンロード

WARNING: Certificates from chef-server99.cs93cloud.internal will be fetched and placed in your trusted_cert
directory (/root/.chef/trusted_certs).

Knife has no means to verify these are the correct certificates. You should
verify the authenticity of these certificates after downloading.

Adding certificate for chef-server99.cs93cloud.internal in /root/.chef/trusted_certs/chef-server99_cs93cloud_internal.crt


# knife configure -i
Overwrite /root/.chef/knife.rb? (Y/N) Y
Please enter the chef server URL: [https://chef-server99.cs93cloud.internal:443]
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


【chef-clientの作成】
@chef-server側で下記のコマンドを実行


【server側からみて、clientが追加されている事が確認】
# knife bootstrap test-httpd -x root -P xxxxxx
# knife node list
test-httpd


【chef-server側でレシピを作成】
# wget --no-check-certificate -O ./chef-repo.tar.gz http://github.com/opscode/chef-repo/tarball/master
# tar xvfz chef-repo.tar.gz
# mv chef-chef-repo-e3efb8c chef-repo


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
Uploading httpd        [0.1.0]
Uploaded 1 cookbook.


【chef-clientに実行させるレシピを追加】
# knife node run_list add test-httpd.cs93cloud.internal 'recipe[httpd]'
test-httpd.cs93cloud.internal:

knife berkshelfをインストールしてくれる。
※gem berkshelfをインストールしようとすると、メモリ不足（2GB）で終了しなかった。
#rpm -ivh https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chefdk-0.3.0-1.x86_64.rpm


# cd cookbooks/
[root@chef-server100 cookbooks]# ls
README.md  riak
[root@chef-server100 cookbooks]# berks cookbook riak
      create  riak/files/default
      create  riak/templates/default
       exist  riak/attributes
       exist  riak/libraries
      create  riak/providers
       exist  riak/recipes
      create  riak/resources
    conflict  riak/recipes/default.rb
Overwrite /var/chef/chef-repo/cookbooks/riak/recipes/default.rb? (enter "h" for help) [Ynaqdh]
       force  riak/recipes/default.rb
    conflict  riak/metadata.rb
Overwrite /var/chef/chef-repo/cookbooks/riak/metadata.rb? (enter "h" for help) [Ynaqdh]
       force  riak/metadata.rb
      create  riak/LICENSE
    conflict  riak/README.md
Overwrite /var/chef/chef-repo/cookbooks/riak/README.md? (enter "h" for help) [Ynaqdh]
       force  riak/README.md
    conflict  riak/CHANGELOG.md
Overwrite /var/chef/chef-repo/cookbooks/riak/CHANGELOG.md? (enter "h" for help) [Ynaqdh]
       force  riak/CHANGELOG.md
    conflict  riak/Berksfile
Overwrite /var/chef/chef-repo/cookbooks/riak/Berksfile? (enter "h" for help) [Ynaqdh]
       force  riak/Berksfile
      create  riak/Thorfile
      create  riak/chefignore
    conflict  riak/.gitignore
Overwrite /var/chef/chef-repo/cookbooks/riak/.gitignore? (enter "h" for help) [Ynaqdh]
       force  riak/.gitignore
    conflict  riak/Gemfile
Overwrite /var/chef/chef-repo/cookbooks/riak/Gemfile? (enter "h" for help) [Ynaqdh]
       force  riak/Gemfile
    conflict  .kitchen.yml
Overwrite /var/chef/chef-repo/cookbooks/riak/.kitchen.yml? (enter "h" for help) [Ynaqdh]
       force  .kitchen.yml
      append  Rakefile
      append  Thorfile
       exist  test/integration/default
      append  .gitignore
      append  .gitignore
      append  Gemfile
      append  Gemfile
You must run `bundle install' to fetch any new gems.
      create  riak/Vagrantfile
[root@chef-server100 cookbooks]#
[root@chef-server100 cookbooks]# ls
README.md  riak
[root@chef-server100 cookbooks]# knife cookbook upload riak -o /var/chef/chef-repo/cookbooks
Uploading riak         [0.1.0]
Uploaded 1 cookbook
```

### chef-clientのインストール
```
@centOS6.5
ホスト名が名前解決できる事が前提。


【Chef-clientのインストール】
# knife bootstrap <ホスト名> -x root -P xxxxxxx

Connecting to test-httpd
test-httpd Installing Chef Client...
test-httpd --2015-01-28 02:10:28--  https://www.opscode.com/chef/install.sh
test-httpd www.opscode.com をDNSに問いあわせています... 184.106.28.90
test-httpd www.opscode.com|184.106.28.90|:443 に接続しています... 接続しました。
test-httpd HTTP による接続要求を送信しました、応答を待っています... 200 OK
test-httpd 長さ: 18285 (18K) [application/x-sh]
test-httpd `STDOUT' に保存中
test-httpd
100%[======================================>] 18,285      --.-K/s 時間 0.002s
test-httpd
test-httpd 2015-01-28 02:10:30 (10.3 MB/s) - stdout へ出力完了 [18285/18285]
test-httpd
test-httpd Downloading Chef 12 for el...
test-httpd downloading https://www.opscode.com/chef/metadata?v=12&prerelease=false&nightlies=false&p=el&pv=6&m=x86_64
test-httpd   to file /tmp/install.sh.1139/metadata.txt
test-httpd trying wget...
test-httpd url     https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-12.0.3-1.x86_64.rpm
test-httpd md5     3634d1a3b6ae2e5977361075da0f44cc
test-httpd sha256     0ec6162b9d0ca2b2016ff02781d84905f712d64c7a81d01b0df88f977832f310
test-httpd downloaded metadata file looks valid...
test-httpd downloading https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-12.0.3-1.x86_64.rpm
test-httpd   to file /tmp/install.sh.1139/chef-12.0.3-1.x86_64.rpm
test-httpd trying wget...
test-httpd Comparing checksum with sha256sum...
test-httpd Installing Chef 12
test-httpd installing with rpm...
test-httpd 警告: /tmp/install.sh.1139/chef-12.0.3-1.x86_64.rpm: ヘッダ V4 DSA/SHA1 Signature, key ID 83ef826a: NOKEY
test-httpd 準備中...                ########################################### [100%]
test-httpd    1:chef                   ########################################### [100%]
test-httpd Thank you for installing Chef!
test-httpd Starting first Chef Client run...
test-httpd Starting Chef Client, version 12.0.3
test-httpd Creating a new client identity for test-httpd using the validator key.
test-httpd [2015-01-28T02:11:06+00:00] ERROR: Error connecting to https://chef-server99.cs93cloud.internal/clients, retry 1/5
test-httpd resolving cookbooks for run list: []
test-httpd Synchronizing Cookbooks:
test-httpd Compiling Cookbooks...
test-httpd [2015-01-28T02:11:11+00:00] WARN: Node test-httpd has an empty run list.
test-httpd Converging 0 resources
test-httpd
test-httpd Running handlers:
test-httpd Running handlers complete
test-httpd Chef Client finished, 0/0 resources updated in 13.898639659 seconds


【chef-server側で追加したレシピを実行】
# chef-client
Starting Chef Client, version 12.0.3
resolving cookbooks for run list: []
Synchronizing Cookbooks:
Compiling Cookbooks...
[2015-01-28T03:57:30+00:00] WARN: Node test-httpd.cs93cloud.internal has an empty run list.
Converging 0 resources

Running handlers:
Running handlers complete
Chef Client finished, 0/0 resources updated in 1.47644249 seconds
[root@test-httpd ~]#
[root@test-httpd ~]# chef-client
Starting Chef Client, version 12.0.3
resolving cookbooks for run list: []
Synchronizing Cookbooks:
Compiling Cookbooks...
[2015-01-28T03:58:42+00:00] WARN: Node test-httpd.cs93cloud.internal has an empty run list.
Converging 0 resources

Running handlers:
Running handlers complete
Chef Client finished, 0/0 resources updated in 1.482467818 seconds
[root@test-httpd ~]# chef-client
Starting Chef Client, version 12.0.3
resolving cookbooks for run list: ["httpd"]
Synchronizing Cookbooks:
  - httpd
Compiling Cookbooks...
Converging 1 resources
Recipe: httpd::default
  * yum_package[httpd] action install
    - install version 2.2.15-39.el6.centos of package httpd

Running handlers:
Running handlers complete
Chef Client finished, 1/1 resources updated in 21.598509989 seconds



【httpdがインンストールされているかの確認】
# rpm -qa | grep httpd
httpd-tools-2.2.15-39.el6.centos.x86_64
httpd-2.2.15-39.el6.centos.x86_64
```
