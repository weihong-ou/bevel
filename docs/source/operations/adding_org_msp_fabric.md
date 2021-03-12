<a name = "adding-org-msp-to-existing-channel-in-fabric"></a>
# Adding an organization's MSP in existing channel

- [Prerequisites](#prerequisites)
- [Modifying configuration file](#create_config_file)
- [Running playbook to deploy Hyperledger Fabric network](#run_network)


<a name = "prerequisites"></a>
## Prerequisites
To add an organization's MSP to an existing channel, a fully configured Fabric network must be present already, i.e. a Fabric network which has Orderers, Peers, Channels (with all Peers already in the channels). The corresponding crypto materials should be available for the target organization and kept in the following folder path - `blockchain-automation-framework/platforms/hyperledger-fabric/configuration/build/crypto-config/peerOrganizations/{target-org-namespace}/msp/`. 

---
**NOTE**: Addition of an organization's MSP has been tested on an existing network which is created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team.

---

<a name = "create_config_file"></a>
## Modifying Configuration File

Refer [this guide](./fabric_networkyaml.md) for details on editing the configuration file.

While modifying the configuration file(`network.yaml`) for adding new organization, all the existing organizations should have `org_status` tag as `existing` and the new organization should have `org_status` tag as `new` under `network.channels` eg.

    network:
      channels:
      - channel:
        ..
        ..
        participants:
        - organization:
          ..
          ..
          org_status: new  # new for new organization(s)
        - organization:
          ..
          ..
          org_status: existing  # existing for old organization(s)

and under `network.organizations` as

    network:
      organizations:
        - organization:
          ..
          ..
          org_status: new  # new for new organization(s)
        - organization:
          ..
          ..
          org_status: existing  # existing for old organization(s)

The `network.yaml` file should contain the specific `network.organization` patch along with the orderer information.


For reference, see `network-fabric-add-organization.yaml` file [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/samples).

<a name = "run_network"></a>
## Run playbook

The [add-organization-msp.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/shared/configuration/add-organization-msp.yaml) playbook is used to add an organization's MSP to an existing channel. This can be done using the following command

```
ansible-playbook platforms/shared/configuration/add-organization-msp.yaml --extra-vars "@path-to-network.yaml"
```

The output of the above playbook is a `Config Envelope` which further need to be signed by the target organization. This envelope is made available at `blockchain-automation-framework/platforms/hyperledger-fabric/configuration/build/` folder path.

---
**NOTE:** This playbook should be executed by the organization who is a creator of the respective channel and has access to the orderer service. Make sure that the `org_status` label was set as `new` when the network is deployed for the first time. If you have additional applications, please deploy them as well.
