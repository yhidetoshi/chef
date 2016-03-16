# chef-server/client インストール方法　レシピ など

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
