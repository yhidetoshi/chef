case node[:platform]
  when 'redhat', 'centos'
    package "git" do
    not_if 'which git'
  end
end
