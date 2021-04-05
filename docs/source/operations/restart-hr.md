<a name = "restart-hr"></a>
# Restart Org's K8S Helm Releases

- [Prerequisites](#prerequisites)
- [Modifying configuration file](#create_config_file)
- [Running playbook to deploy Hyperledger Fabric network](#run_network)


<a name = "prerequisites"></a>
## Prerequisites
To add a new organization a fully configured Fabric network must be present already, i.e. a Fabric network which has Orderers, Peers, Channels (with all Peers already in the channels). 

---
**NOTE**:  Restarting helm releases for an organization has been tested on existing components which were created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team.

---

<a name = "create_config_file"></a>
## Modifying Configuration File

The playbook needs details of only those Org, whose components needs to be restarted.

While modifying the configuration file(`network.yaml`), `components` section needs to be added to the corresponding `network.organizations` section. The `components` section shall contain a list of resources needed to be restarted.

    network:
      organizations:
        - organization:
          ..
          ..
          components:
            - org1-peer0-0
            - org1-peer1-0
        - organization:
          ..
          ..
          components:
            - org2-orderer0
            - org2-orderer1

For reference, see `network-fabricv2-restart-helm-releases.yaml` file [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/samples).

<a name = "run_network"></a>
## Run playbook

The [restart-helm-releases.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/restart-helm-releases.yaml) playbook is used to restart k8s components for an organization. This can be done using the following command:

```
ansible-playbook platforms/hyperledger-fabric/configuration/restart-helm-releases.yaml --extra-vars "@path-to-network.yaml"
```
