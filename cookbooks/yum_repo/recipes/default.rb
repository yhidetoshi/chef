user 'root'
  code <<-EOC
    rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
    sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/epel.repo
  EOC
end
