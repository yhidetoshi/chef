=begin
execute "get-file-wordpress" do
    user "root" 
    command <<-EOH 
	git clone #{node['file']['wordpress']}
        mv wordpress /var/www/
    EOH
    #command "wget -P /var/www/ https://github.com/yhidetoshi/wordpress"
end
=end

=begin
# packages isntall
install_packages = %w[
	php php-mbstring php-mysql php-fpm mysql-server
]

install_packages.each do |pkg|
  bash "install_#{pkg}" do
	user "root"
  	code <<-EOC
	  yum clean all
          yum -y install #{pkg}
        EOC
   end
end

# mysql_auto_start
service "mysqld" do
  supports :status => true, :restart => true, :reload => true
  action[:enable, :start]
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
  command "/usr/bin/mysql -u root -p#{root_password} < #{Chef::Config[:file_cache_path]}/create_db.sql"
  action :nothing
  not_if "/usr/bin/mysql -u root -p#{root_password} -D #{db_name}"
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
   command "/usr/bin/mysql -u root -p#{user_password} < #{Chef::Config[:file_cache_path]}/create_user.sql"
   action :nothing
   not_if "/usr/bin/mysql -u #{user_name} -p#{user_password} -D #{db_name}"
end

template "#{Chef::Config[:file_cache_path]}/create_user.sql" do
  owner "root"
  group "root"
  mode 0644
  source "create_user.sql.erb"
  variables({
	:db_name => db_name,
        :username => user_name,
        :password => user_password,
  })
  notifies :run, "execute[create_user]", :immediately
end


=end

=begin
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
=end

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

=begin
# set php.ini
template "/etc/php.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode 0644
end
=end
