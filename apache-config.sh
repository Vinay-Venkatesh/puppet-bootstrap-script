#!/bin/bash
module_path="/etc/puppetlabs/code/environment/production/modules"
log_dir_location="/etc/logs"
manifest_path="/etc/puppetlabs/code/environment/production/modules/apache2"
instance_specific_module_name="apache2"

#Module directory
if [ -d "$module_path" ];then
        echo "Directory exists"
else
        mkdir -p "$module_path"
fi

#Log directory
if [ -d "$log_dir_location" ];then
        echo "Directory exists"
else
        mkdir -p "$log_dir_location"
fi

#Clone the repository
cd /tmp && git clone --branch master https://github.com/xxCoDeBoX/apache-configuration.git

#Move the cloned repository to /etc/puppet/modules location.
cd /tmp && cp -r apache-configuration/* "$module_path"

if [ -d "$manifest_path" ];then
        cd $module_path && rm -rf "$instance_specific_module_name"
        cd /tmp/apache-configuration && cp -r "$instance_specific_module_name" "$module_path"
else
        cd /tmp/apache-configuration && cp -r "$instance_specific_module_name" "$module_path"
fi

#Remove the repositories
cd /tmp && rm -rf apache-configuration

#Run puppet agent
/usr/bin/puppet apply -d  --modulepath=$module_path "$manifest_path"/site.pp >> /etc/logs/puppet.log
