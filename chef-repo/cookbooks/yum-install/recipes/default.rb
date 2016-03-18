update_packages = %w[
 emacs
]

update_packages.each do |pkg|
  bash "update_#{pkg}" do
    user 'root'
    code << EOC
	yum clean all
	yum -y install #{pkg}
    EOC
   end
 end
