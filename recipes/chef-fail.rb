#does not look like there is a node attribute for this, but there should be
error_file = "#{Chef::Config[:file_cache_path]}/failed-run-data.json"

if node['chef_client']['log_dir']
	log_dir = node['chef_client']['log_dir']
	if node['chef_client']['log_file']
		log_dir += "/#{node['chef_client']['log_file']}"
	end
else
	log_dir = ""
end

#this file will be recreated if/when chef fails
file error_file do
    owner   "root"
    group   "root"
    mode    "0755"
    action  :delete
end

sch_motd "100-chef-fail" do
    source      'chef-fail.erb'
    variables   error_file: error_file,
                log_dir: log_dir

    only_if { ::File.directory? '/etc/update-motd.d' }
end