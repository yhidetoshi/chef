execute "get-file-wordpress" do
    user "root"
    command <<-EOH 
	git clone #{node['file']['wordpress']} #{node['path']['wordpress']}
        chown -R #{node['web']['name']}:#{node['web']['name']} #{node['path']['wordpress']}
    EOH
end

# packages isntall
install_packages = %w[
	php php-mbstring php-mysql mysql-server php-fpm
]

install_packages.each do |pkg|
  bash "install_#{pkg}" do
	user "root"
  	code <<-EOC
          yum -y install #{pkg}
        EOC
   end
end

execute 'chkconfig_php-fpm_on' do
  command "chkconfig php-fpm on"
end

execute 'chkconfig_mysqld_on' do
  command "chkconfig mysqld on"
end

execute 'service_mysqld_start' do
  command "service mysqld start"
end

# mysql_auto_start
service "mysqld" do
  supports :status => true, :restart => true, :reload => true
  #action[:enable, :start]
end

# mysql_secure_install
root_password = node["mysql"]["root_password"]
execute "secure_install" do
  command "/usr/bin/mysql -u root < #{Chef::Config[:file_cache_path]}/secure_install.sql"
  action :nothing
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end

template "#{Chef::Config[:file_cache_path]}/secure_install.sql" do
  owner "root"
  group "root"
  mode 0644
  source "secure_install.sql.erb"
  variables({
	:root_password => root_password,
  })
  notifies :run, "execute[secure_install]", :immediately
end

# create DB
db_name = node["mysql"]["db_name"]
execute "create_db" do
  command "/usr/bin/mysql -u root -p #{root_password} < #{Chef::Config[:file_cache_path]}/create_db.sql"
  action :nothing
  not_if "/usr/bin/mysql -u root -p #{root_password} -D #{db_name}"
end

template "#{Chef::Config[:file_cache_path]}/create_db.sql" do
  owner "root"
  group "root"
  mode 0644
  source "create_db.sql.erb"
  variables({
     :db_name => db_name,
  })
  notifies :run, "execute[create_db]", :immediately
end

# create User
user_name	= node["mysql"]["user"]["name"]
user_password   = node["mysql"]["user"]["password"]
execute "create_user" do
   command "/usr/bin/mysql -u root -p #{user_password} < #{Chef::Config[:file_cache_path]}/create_user.sql"
   action :nothing
   not_if "/usr/bin/mysql -u #{user_name} -p #{user_password} -D #{db_name}"
end

template "#{Chef::Config[:file_cache_path]}/create_user.sql" do
  owner "root"
  group "root"
  mode 0644
  source "create_user.sql.erb"
  variables({
	:db_name => db_name,
        :username => user_name,
        :password => user_password
  })
  notifies :run, "execute[create_user]", :immediately
end

# set_wordpress_config
template "/var/www/wordpress/wp-config.php" do
  source "wp-config.php.erb"
  owner "nginx"
  group "nginx"
  mode 0644
  variables(
	:db_name => node['mysql']['db_name'],
	:db_user => node['mysql']['user']['name'],
	:db_pass => node['mysql']['user']['password']
 )
end

# set php-fpm
template "/etc/php-fpm.d/www.conf" do
  source "www.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
	:web_name => node['web']['name']
)
end

# set php.ini
template "/etc/php.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode 0644
end

