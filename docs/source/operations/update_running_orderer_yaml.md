<a name = "custom-core-yaml-orderer"></a>
# Update running orderer.yaml for orderers using BAF

To fetch the current orderer.yaml refer to [this guide](./fetch_core_yaml). Once the current orderer.yaml is available, proceed witht he desired updates and execute the below playbook:

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

While modifying the configuration file(`network.yaml`), the path to the custom Fabric CA Server configration, `configpath`, can be added under `network.organizations.services.orderers` as follows

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
                configpath:
          ..
          ..     

*_In case customization is not needed do not add this variable in your `network.yaml`_*

Refer [this sample](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml) for details on the configuration file.