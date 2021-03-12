<a name = "deploy-peer-only"></a>
# Deploying an organization's Peers only

- [Prerequisites](#prerequisites)
- [Modifying configuration file](#create_config_file)
- [Running playbook to deploy Hyperledger Fabric network](#run_network)


<a name = "prerequisites"></a>
## Prerequisites
To deploy only peer nodes for a given organization, Orderer Service's TLS Certificates are required and made available at `blockchain-automation-framework/platforms/hyperledger-fabric/configuration/build/crypto-config/ordererOrganizations/acn-ord-net/orderers/orderer1.acn-ord-net/tls/ca.crt` path for the respective peers. The corresponding crypto materials should also be present in their respective Hashicorp Vault. 

---
**NOTE**:  Deployment of only peer nodes for an organization has been tested on an existing ordering service which is created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team.

---

<a name = "create_config_file"></a>
## Modifying Configuration File

While modifying the configuration file(`network.yaml`) for deploying only peers, information regarding Orderer organization under `network.organizations` section as well as information regarding `network.channels` is not required. Rest of the section are required per [this guide](./fabric_networkyaml.md).

For reference, see `network-fabricv2-only-peers.yaml` file [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/samples).

<a name = "run_network"></a>
## Run playbook

The [deploy-only-peers.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/deploy-only-peers.yaml) playbook is used to add a new organization to the existing network. This can be done using the following command

```
ansible-playbook platforms/shared/configuration/site.yaml --extra-vars "@path-to-network.yaml" --extra-vars "peers_only=true"
```
