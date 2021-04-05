<a name = "custom-core-yaml-peer"></a>
# Use custom core.yaml to deploy peers using BAF

The [helm chart for Peer Nodes](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/charts/peernode) has been equiped with a ConfigMap generated from a config file and resides inside the chart in the [conf folder](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/charts/peernode/conf).

---
**IMPORTANT**: Since BAF auto-generates the Peer Identity, this config file has been templatized to address the same. Sample template is as follows

```yaml
    peer:

      # The peer id provides a name for this peer instance and is used when
      # naming docker resources.
      id: {{ $.Values.peer.name }}.{{ $.Values.metadata.namespace }}

      # The networkId allows for logical separation of networks and is used when
      # naming docker resources.
      networkId: {{ $.Values.peer.name }}.{{ $.Values.metadata.namespace }}

      # The Address at local network interface this Peer will listen on.
      # By default, it will listen on all network interfaces
      listenAddress: 0.0.0.0:7051

      # The endpoint this peer uses to listen for inbound chaincode connections.
      # If this is commented-out, the listen address is selected to be
      # the peer's address (see below) with port 7052
      # chaincodeListenAddress: 0.0.0.0:7052

      # The endpoint the chaincode for this peer uses to connect to the peer.
      # If this is not specified, the chaincodeListenAddress address is selected.
      # And if chaincodeListenAddress is not specified, address is selected from
      # peer address (see below). If specified peer address is invalid then it
      # will fallback to the auto detected IP (local IP) regardless of the peer
      # addressAutoDetect value.
      # chaincodeAddress: 0.0.0.0:7052

      # When used as peer config, this represents the endpoint to other peers
      # in the same organization. For peers in other organization, see
      # gossip.externalEndpoint for more info.
      # When used as CLI config, this means the peer's endpoint to interact with
      address: {{ $.Values.peer.name }}.{{ $.Values.metadata.namespace }}:{{ $.Values.service.ports.grpc.clusteripport }}

```

---

By default, this [config file](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/charts/peernode/conf/default_core.yaml.yaml) is being used to generate Peer container.

In case, customization is to be done in the peer configuration, it is recommended to make a copy of the above stated file, edit and save it either outside the BAF project's root folder or in any `build/` folder inside the BAF Project. *DO NOT save the custom file directly in the helm chart.*
Once the customized config is ready, the absolute path for the same can be provided in your `network.yaml` as described in the below section. 

---
**NOTE**: Custom Peer configuration using BAF has been tested on network which is created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team.

---

## Modifying Configuration File

Refer [this guide](./fabric_networkyaml.md) for details on editing the configuration file.

While modifying the configuration file(`network.yaml`), the path to the custom core.yaml configration, `configpath`, can be added under `network.organizations.services.peers` as follows

    network:
      channels:
      - channel:
        ..
        ..
        participants:
      organizations:
        - organization:
          services:
            peers:
              name:
              type: 
              gossippeeraddress:
              cli:
              grpc:
                port: 
              core_yaml:
                initialize_from
                configpath:
          ..
          ..      

*_In case customization is not needed do not add this variable in your `network.yaml`_*

Refer [this sample](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml) for details on the configuration file.