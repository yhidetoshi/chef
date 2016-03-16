define :httpd_install do
   yum_package "#{node['yum']['package1']}" do
      action :install
   end
end
