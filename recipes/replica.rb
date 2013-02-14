#
# Cookbook Name:: ipa_server
# Recipe:: replica
#
# Copyright (C) 2013 Joseph Anthony Pasquale Holsten
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'base64'

ipa_server_package node['ipa_server']['hostname'] do
  action :install
end

# TODO: fine tuned firewall rules
execute "iptables --flush"

bag_name = node['fqdn'].tr('.', '_')
replica_info = data_bag_item('ipa_replicas', bag_name)
if replica_info['content']
  file "/var/lib/ipa/replica-info-#{node['fqdn']}.gpg" do
    content Base64.decode64(replica_info['content'])
    owner 'root'
    group 'root'
    mode '0600'
    action :create_if_missing
  end

  ruby_block 'set node["ipa_server"]["needs_key"] = false' do
    block do
      node.set['ipa_server']['replica']['needs_key'] = false
      node.save
    end
    only_if {::File.exists? "/var/lib/ipa/replica-info-#{node['fqdn']}.gpg" }
  end

  execute "ipa-replica-install" do
    command <<-EOF
    ipa-replica-install \
    --password=#{node['ipa_server']['ds_password']} \
    --admin-password=#{node['ipa_server']['admin_password']} \
    /var/lib/ipa/replica-info-#{node['fqdn']}.gpg
    EOF
    not_if { ::File.exists? '/etc/ipa/default.conf' }
  end
else
  Chef::Log.warn "Can not set up replication without replica info for this node. Could not find contents in data_bag_item[ipa_replica_info::#{bag_name}]. #{replica_info.inspect}"
end
