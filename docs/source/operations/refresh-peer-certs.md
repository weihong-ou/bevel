<a name = "refresh-peer-certs"></a>
# Refreshing Peer Certificates

- [Prerequisites](#prerequisites)
- [Modifying configuration file](#create_config_file)
- [Running playbook to deploy Hyperledger Fabric network](#run_network)


<a name = "prerequisites"></a>
## Prerequisites
To add a new organization a fully configured Fabric network must be present already, i.e. a Fabric network which has Orderers, Peers, Channels (with all Peers already in the channels). 

---
**NOTE**:  Refreshing Peer Certificates for an organization has been tested on an existing ordering service which is created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team.

---

<a name = "create_config_file"></a>
## Modifying Configuration File

The playbook needs details of only Peer Org, whose certificates needs to be refreshed.

For reference, see `network-fabricv2-refresh-peer-certs.yaml` file [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/samples).

<a name = "run_network"></a>
## Run playbook

The [refresh-peer-certs.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/refresh-peer-certs.yaml) playbook is used to refresh Peer Certificates for an organization. This can be done using the following command:

```
ansible-playbook platforms/hyperledger-fabric/configuration/restart-pods.yaml --extra-vars "@path-to-network.yaml"
```
