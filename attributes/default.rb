default['ipa_server']['hostname'] = node['fqdn']
default['ipa_server']['domain'] = node['fqdn'].split('.')[1..-1].join('.')
default['ipa_server']['realm'] = node['fqdn'].split('.')[1..-1].join('.').upcase
default['ipa_server']['ds_password'] = 'password'
default['ipa_server']['admin_password'] = 'password'
