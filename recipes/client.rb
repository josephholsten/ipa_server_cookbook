package 'freeipa-client'

execute 'ipa-client-install' do
  command <<-EOF
  sudo \
  ipa-client-install \
  --principal=#{node['ipa_server']['client']['principal']} \
  --password=#{node['ipa_server']['client']['password'] } \
  --unattended
  EOF
  not_if { ::File.exists? '/etc/ipa/default.conf' }
end
