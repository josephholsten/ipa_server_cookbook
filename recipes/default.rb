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
