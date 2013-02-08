#
# Cookbook Name:: ipa_server
# Provider:: package
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

action :install do
  ipa_server_package new_resource.hostname do
    action :install
  end

  execute "ipa-server-install" do
    command <<-EOF
    ipa-server-install \
    --hostname=#{new_resource.hostname} \
    --domain=#{new_resource.domain} \
    --realm=#{new_resource.realm} \
    --ds-password=#{new_resource.ds_password} \
    --admin-password=#{new_resource.admin_password} \
    --setup-dns \
    --no-forwarders \
    --unattended
    EOF
    not_if { ::File.exists? '/etc/ipa/default.conf' }
  end

  new_resource.updated_by_last_action(true)
end

action :remove do
  execute "ipa-server-uninstall" do
    command <<-EOF
    --uninstall \
    --unattended
    EOF
    only_if { ::File.exists? '/etc/ipa/default.conf' }
  end

  ipa_server_package new_resource.name do
    action :remove
  end

  new_resource.updated_by_last_action(true)
end
