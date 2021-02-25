<a name = "generating-custom-user-certificate-using-fabric-ca-with-baf"></a>
# Generating User Certificates with custom attributes using Fabric CA in BAF for Peer Organizations

- [Generating User Certificates with custom attributes using Fabric CA in BAF for Peer Organizations](#generating-custom-user-certificate-using-fabric-ca-with-baf)
  - [While setting up a new network](#new-network)
  - [In an existing Fabric Network with Fabric CA](existing-network)

<a name = "new-network"></a>
## While setting up a new network
When setting up a brand new Hyperledger Fabric network using BAF, the `users` section of corresponding `organization` section from [network.yaml](./fabric_networkyaml.md) can be used to configure custom attributes for various users.
BAF will use this section to generate custom attributes for User MSPs using `fabric-ca-client` for the corresponding organisation and store them to vault securely for further usage.

---
**NOTE**:Generating User Certificates with custom attributes using Fabric CA in BAF for Peer Organizations has been tested on network which is created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team. The CA used is Fabric-CA

---

## Modifying Configuration File

Refer [this guide](./fabric_networkyaml.md) for details on editing the configuration file.

While modifying the configuration file(`network.yaml`), user details can be added under `network.organizations` as follows

    network:
      channels:
      - channel:
        ..
        ..
        participants:
      organizations:
        - organization:
          users:
            - user:
              identity: User1
              attributes:
                - key: key1
                  value: value1
                - key: key2
                  value: value2
                  ..
                  ..
              ..
              ..  
          ..
          ..      


<a name = "existing-network"></a>
## In an existing Fabric Network with Fabric CA
In order to create new users or update existing user's attrs, `user-certificate.yaml` playbook can be used with a minimum configuration as listed in [this sample](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/samples/network-user-certificate.yaml)

---
**NOTE**:Generating User Certificates with custom attributes using Fabric CA in BAF for Peer Organizations has been tested on network which is created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team. The CA used is Fabric-CA

---

## Run playbook

The [user-certificate.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/user-certificate.yaml) playbook can be executed using the following command

```
ansible-playbook user-certificate.yaml --extra-vars "@path-to-network-user-certificate.yaml"
```

---
**NOTE:** The `user-certificate.yaml` is not required when the network is deployed for the first time.
