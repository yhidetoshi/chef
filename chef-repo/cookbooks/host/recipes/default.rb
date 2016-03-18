template "hosts" do
   action :create
   path "/etc/hosts"
   mode "0644"
   backup 5
end
