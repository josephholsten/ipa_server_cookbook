#
# Cookbook Name:: ipa_server
# Recipe:: default
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

ipa_server node['ipa_server']['hostname'] do
  domain node['ipa_server']['domain']
  realm node['ipa_server']['realm']
  ds_password node['ipa_server']['ds_password']
  admin_password node['ipa_server']['admin_password']
end

# populate nodes for replica info
search('node', 'ipa_server_replica_enabled:true') do |replica|
  # ensure dns record exists
  execute "ipa dnsrecord-add #{replica['domain']} #{replica['hostname']}" do
    command <<-EOF
      echo #{node['ipa_server']['admin_password']} | \
      kinit admin; \
      ipa dnsrecord-add \
        #{replica['domain']} #{replica['hostname']} \
        --a-ip-address #{replica['ipaddress']} \
        --a-create-reverse
    EOF
    not_if "dig #{replica['fqdn']} +short | grep '^.*$'"
  end

  # prepare replica
  execute "ipa-replica-prepare #{replica['fqdn']}" do
    command <<-EOF
      ipa-replica-prepare \
        #{replica['fqdn']} \
        --password #{node['ipa_server']['ds_password']}
    EOF
    not_if { ::File.exists? "/var/lib/ipa/replica-info-#{replica['fqdn']}.gpg" }
  end

  # ensure bag exists
  bag = begin
    data_bag('ipa_replicas')
  rescue
    Chef::DataBag.json_create('name' => 'ipa_replicas').save
  end

  bag_name = replica['fqdn'].tr('.','_')
  replica_bag_item = begin
    data_bag_item('ipa_replicas', bag_name)
  rescue
   Chef::DataBagItem.json_create(
     'data_bag' => 'ipa_replicas',
     'raw_data' => {'id' => bag_name})
  end
  ruby_block "set data_bag_item[ipa_replicas::#{bag_name}]['content']" do
    block do
      require 'base64'
      replica_info = ::File.read("/var/lib/ipa/replica-info-#{replica['fqdn']}.gpg")
      replica_bag_item['content'] = Base64.encode64(replica_info)

      begin
        replica_bag_item.save
      rescue
        raise "Could not save data_bag_item[ipa_replicas::#{bag_name}]. Check that this node permission to modify the data bag (or is an admin in Open Source chef)"
      end
    end
  end
end
