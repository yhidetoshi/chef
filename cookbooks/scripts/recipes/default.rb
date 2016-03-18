directory "/opt/hoge" do
 owner "root"
 group "root"
 mode 00755
 action :create
end

#cookbook_file "add_test_file.sh" do
#  action :create
#  path /opt/chef_solo_add_file/add_test_file.sh
#  mode "0755"
#end
