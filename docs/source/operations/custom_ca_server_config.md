<a name = "custom-fabric-ca-server-configuration"></a>
# Use custom Fabric CA Server configuration while deploying Fabric CA using BAF

The [helm chart for Fabric CA Server](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/charts/ca) has been equiped with a ConfigMap generated from a config file. This config file corresponds to [Fabric CA Server Configuration File](https://hyperledger-fabric-ca.readthedocs.io/en/release-1.4/serverconfig.html) and resides inside the chart in the [conf folder](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/charts/ca/conf).

---
**IMPORTANT**: Since BAF auto-generates the CA Admin Identity, this config file has been templatized to address the same. The template is as follows

```yaml
    registry:
      # Maximum number of times a password/secret can be reused for enrollment
      # (default: -1, which means there is no limit)
      maxenrollments: -1

      # Contains identity information which is used when LDAP is disabled
      # Do not edit the templatized values
      identities:
        - name: {{ $.Values.server.admin }}
          pass: {{ $.Values.server.admin }}pw
          type: client
          affiliation: ""
          attrs:
              hf.Registrar.Roles: "*"
              hf.Registrar.DelegateRoles: "*"
              hf.Revoker: true
              hf.IntermediateCA: true
              hf.GenCRL: true
              hf.Registrar.Attributes: "*"
              hf.AffiliationMgr: true

```

---

By default, this [config file](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/charts/ca/conf/fabric-ca-server-config-default.yaml) is being used to generate Fabric CA Server pod.

In case, customization is to be done in the server configuration, it is recommended to make a copy of the above stated file, edit and save it either outside the BAF project's root folder or in any `build/` folder inside the BAF Project. *DO NOT save the custom file directly in the helm chart.*
Once the customized config is ready, the absolute path for the same can be provided in your `network.yaml` as described in the below section. 

---
**NOTE**: Using custom Fabric CA Server configuration while deploying Fabric CA using BAF has been tested on network which is created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team.

---

## Modifying Configuration File

Refer [this guide](./fabric_networkyaml.md) for details on editing the configuration file.

While modifying the configuration file(`network.yaml`), the path to the custom Fabric CA Server configration, `configpath`, can be added under `network.organizations.service.ca` as follows

    network:
      channels:
      - channel:
        ..
        ..
        participants:
      organizations:
        - organization:
          services:
            ca:
              name: 
              subject:
              type:
              grpc:
                port: 
              configpath:
          ..
          ..      

*_In case customization is not needed do not add this variable in your `network.yaml`_*

Refer [this sample](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml) for details on the configuration file.