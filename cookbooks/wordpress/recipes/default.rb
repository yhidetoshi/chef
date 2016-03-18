execute "get-file-wordpress" do
    user "root" 
    command <<-EOH 
	git clone #{node['file']['wordpress']}
        mv wordpress /var/www/
    EOH
    #command "wget -P /var/www/ https://github.com/yhidetoshi/wordpress"
end
