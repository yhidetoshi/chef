package "nginx" do
  action :install
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

