package "nginx" do
  action :install
  not_if 'which nginx'
end

execute 'chkconfig_nginx_on' do
  command "chkconfig nginx on"
end

template "/etc/nginx/conf.d/wp.conf" do
  source "wordpress.conf.erb"
  owner  "root"
  group  "root"
  mode  0644
  variables({
	:hostname => `/bin/hostname`.chomp
  })
end

