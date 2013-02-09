# <a name="title"></a> ipa_server

## <a name="description"></a> Description

Installs and configures [FreeIPA](http://freeipa.org/page/Main_Page).

# <a name="usage"></a> Usage


## To set up an initial master ipa server

Ensure the FQDN of the node is correctly configured before applying this
recipe.

Apply the `ipa_server::default` recipe to the run list of your node or
role.

## To set up a replica of your ipa server

Go to your master ipa server and run

    ipa-replica-prepare ipareplica.example.com

where ipareplica.example.com is the fqdn of the node that will be your replica
server. It will create a file `/var/lib/ipa/replica-info-ipareplica.example.com.gpg`.

Make this file available at an HTTP url. Place this in the node's
`node['ipa_server']['replica_file']`.

Then apply the `ipa_server::replica` recipe to the run list of your node or
role.

# <a name="recipes"></a> Recipes

`default`:: installs the FreeIPA server with the Bind DNS server.


`replica`:: 

# <a name="license"></a> License and Author

Author:: Joseph Anthony Pasquale Holsten (<joseph@josephholsten.com>)

Copyright:: 2013 Joseph Anthony Pasquale Holsten

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
