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

ipa_server_package node['ipa_server']['hostname'] do
  action :install
end

remote_file "/var/lib/ipa/replica-info-#{node['fqdn']}.gpg" do
  source node['ipa_server']['replica_file']
  owner 'root'
  group 'root'
  mode '0664'
  action :create_if_missing
end

execute "ipa-replica-install" do
  command <<-EOF
  ipa-replica-install \
  --password=#{node['ipa_server']['ds_password']} \
  /var/lib/ipa/replica-info-#{node['fqdn']}.gpg
  EOF
  not_if { ::File.exists? '/etc/ipa/default.conf' }
end
