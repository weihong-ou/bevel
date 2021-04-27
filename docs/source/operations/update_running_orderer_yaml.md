<a name = "custom-core-yaml-orderer"></a>
# Update running orderer.yaml for orderers using BAF

To fetch the current orderer.yaml refer to [this guide](./fetch_orderer_yaml). Once the current orderer.yaml is available, proceed with the desired updates and execute the below playbook:

```
ansible-playbook platforms/hyperledger-fabric/configuration/update-orderer-yaml.yaml --extra-vars "@path-to-network.yaml"
```

It is recommended to make a copy of the above stated file, edit and save it either outside the BAF project's root folder or in any `build/` folder inside the BAF Project. *DO NOT save the custom file directly in the helm chart.*

Once the customized config is ready, the absolute path for the same can be provided in your `network.yaml` as described in the below section. 

---
**NOTE**: Updating running orderer.yaml for orderers using BAF has been tested on network which is created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team.

---

## Modifying Configuration File

Refer [this guide](./fabric_networkyaml.md) for details on editing the configuration file.

While modifying the configuration file(`network.yaml`) the belwo defined can be added under `network.organizations.services.orderers` as follows:
- Where to initialize the orderer.yaml from `initialize_from`, i.e. global variables (`global_var`) or file (`file`)
- Incase the aboe is `file`, specify if orderer.yaml contains tempalte vars or real values by a boolean flag, `tpl`, `true` for if tempalte vars exist
- The path to the custom orderer.yaml configration as `configpath`, when initialize_from is `file` else the default template will be considered.
Refer [this guide](./custom_orderer_yaml.md) for details on editing the orderer.yaml file with template vars.

**NOTE:** The template vars are the variables defined in the Helm value file for the corresponding Helm Chart

    network:
      channels:
      - channel:
        ..
        ..
        participants:
      organizations:
        - organization:
          services:
            orderers:
              name:
              type: 
              consensus:
              grpc:
                port: 
              orderer_yaml: 
                initialize_from:
                tpl: 
                configpath:
          ..
          ..     

Refer [this sample](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml) for details on the configuration file.