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
  case node['platform_family']
  when 'rhel'
    package 'ipa-server'
  when 'fedora'
    package 'freeipa-server'
  end
  package 'bind-dyndb-ldap'

  new_resource.updated_by_last_action(true)
end

action :remove do
  case node['platform_family']
  when 'rhel'
    package 'ipa-server' do
      action :remove
    end
  when 'fedora'
    package 'freeipa-server' do
      action :remove
    end
  end
  package 'bind-dyndb-ldap' do
    action :remove
  end

  new_resource.updated_by_last_action(true)
end
