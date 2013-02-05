name             "ipa_server"
maintainer       "Joseph Anthony Pasquale Holsten"
maintainer_email "joseph@josephholsten.com"
license          "Apache 2.0"
description      "Installs/Configures ipa_server"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION')) rescue "0.1.0"

supports 'centos', ">= 6.3"
supports 'fedora', ">= 18"

depends 'yum'
