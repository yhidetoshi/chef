httpd_install
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
