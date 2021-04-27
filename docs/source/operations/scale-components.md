<a name = "scale-org-components"></a>
# Scale Org's K8S Components

- [Prerequisites](#prerequisites)
- [Modifying configuration file](#create_config_file)
- [Running playbook to deploy Hyperledger Fabric network](#run_network)


<a name = "prerequisites"></a>
## Prerequisites
To add a new organization a fully configured Fabric network must be present already, i.e. a Fabric network which has Orderers, Peers, Channels (with all Peers already in the channels). 

---
**NOTE**:  Scaling components for an organization has been tested on existing components which were created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team.

---

<a name = "create_config_file"></a>
## Modifying Configuration File

The playbook needs details of only those Org, whose components needs to be scaled.

While modifying the configuration file(`network.yaml`), `components` section needs to be added to the corresponding `network.organizations` section. The `components` section shall contain a list of resources needed to be restarted.

    network:
      organizations:
        - organization:
          ..
          ..
          components:
            - name: peer0
              replicas: 0
            - name: peer1
              replicas: 0 
        - organization:
          ..
          ..
          components:
            - name: orderer0
              replicas: 0
            - name: orderer0
              replicas: 1

For reference, see `network-fabricv2-scale-org-components.yaml` file [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/samples).

<a name = "run_network"></a>
## Run playbook

The [scale-components.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/scale-components.yaml) playbook is used to scale k8s components for an organization. This can be done using the following command:

```
ansible-playbook platforms/hyperledger-fabric/configuration/scale-components.yaml --extra-vars "@path-to-network.yaml"
```
