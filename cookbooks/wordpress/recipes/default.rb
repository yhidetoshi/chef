#execute "get-file-wordpress" do
#    user "root" 
#    command <<-EOH 
#	git clone #{node['file']['wordpress']}
#        mv wordpress /var/www/
#    EOH
    #command "wget -P /var/www/ https://github.com/yhidetoshi/wordpress"
#end

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
