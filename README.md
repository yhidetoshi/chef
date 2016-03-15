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
