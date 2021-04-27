<a name = "approve-chaincode-fabric"></a>
# Approve chaincode in BAF deployed Hyperledger Fabric Network

- [Pre-requisites](#pre_req)
- [Modifying configuration file](#create_config_file)
- [Running playbook to approve chaincode in BAF deployed Hyperledger Fabric network](#run_network)

<a name = "pre_req"></a>
## Pre-requisites
Hyperledger Fabric network deployed and network.yaml configuration file already set.

<a name = "create_config_file"></a>
## Modifying configuration file

Refer [this guide](./install_instantiate_chaincode.md) for details on editing the configuration file for internal chaincode.
Refer [this guide](./external_chaincode.md) for details on editing the configuration file for external chaincode.

<a name = "run_network"></a>
## Running playbook to approve chaincode in BAF deployed Hyperledger Fabric network

The playbook [approve-chaincode.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/master/platforms/hyperledger-fabric/configuration/approve-chaincode.yaml) is used to approve chaincode for the existing fabric network.
This can be done by using the following command:

```
    ansible-playbook platforms/hyperledger-fabric/configuration/approve-chaincode.yaml --extra-vars "@path-to-network.yaml"
```

---
**NOTE:** The same process is executed for approving multiple chaincodes