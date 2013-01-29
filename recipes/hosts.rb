#
# Cookbook Name:: ipa_server
# Recipe:: hosts
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

execute "append real ip to hosts" do
  command <<-EOF
  echo "#{node['ipaddress']} #{node['fqdn']}" > /tmp/hosts
  cat /etc/hosts |
  sed 's/#{node['fqdn']}//' >> /tmp/hosts
  mv /tmp/hosts /etc/hosts
  EOF
  not_if "grep #{node['ipaddress']} /etc/hosts"
end
