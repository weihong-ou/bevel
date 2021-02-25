<a name = "update-running-channel-config"></a>
# Update running channel configuration using BAF

Once a Hyperledger Fabric network is up, using BAF, BAF users might want to update certain channel configurations on the fly. BAF supports this task by executing the following steps:

 - [Fetch the existing config block in JSON format](#fetch_config_block)
 - [Edit the config block manually](#edit_manually)
 - [Generate envelope from the updated config](#generate_envelope)
 - [Get signatures from Joiner Peers (if required)](#sign_joiner_peers)
 - [Get signatures from Orderer (if required)](#sign_orderer)
 - [Submit the envelope to channel](#submit_to_channel)


<a name = "fetch_config_block"></a>
## Fetch the existing config block in JSON format
The [fetch-channel-config-block.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/shared/configuration/fetch-channel-config-block.yaml) playbook can be used to fetch the existing config block for a channel. This can be done using the following command

```
ansible-playbook platforms/shared/configuration/fetch-channel-config-block.yaml --extra-vars "@path-to-network.yaml"
```

For `network.yaml` reference, see `network-fabricv2.yaml` file [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/samples).

---
**NOTE:** The config block JSON will be copied to `blockchain-automation-framework/build/` folder as <CHANNEL_NAME>_config.json.

<a name = "edit_manually"></a>
## Edit the config block manually
Since there can be several updates to the config block, BAF allows users to edit the configuration manually. \
**DO NOT edit the <CHANNEL_NAME>_config.json file,** because, it is needed to perform the update transaction and compute difference. \
Copy the <CHANNEL_NAME>_config.json file to <CHANNEL_NAME>_updated_config.json in the same `blockchain-automation-framework/build/` folder and start editing/updating the config.

<a name = "generate_envelope"></a>
## Generate envelope from the updated config
The [generate-updated-channel-config-envelope.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/shared/configuration/generate-updated-channel-config-envelope.yaml) playbook can be used to generate the updated config block envelope for updating channel config. 

This playbook requires both, existing and updated config JSON files, namely <CHANNEL_NAME>_config.json and <CHANNEL_NAME>_updated_config.json respectively to be present in the `blockchain-automation-framework/build/` folder. \

This can be done using the following command

```
ansible-playbook platforms/shared/configuration/generate-updated-channel-config-envelope.yaml --extra-vars "@path-to-network.yaml"
```

For `network.yaml` reference, see `network-fabricv2.yaml` file [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/samples).

---
**NOTE:** The config block envelope will be copied to `blockchain-automation-framework/build/` folder as <CHANNEL_NAME>config_update_in_envelope.pb.

<a name = "sign_joiner_peers"></a>
## Get signatures from Joiner Peers (if required)
If the configuration has updates related to joiner peer organizations, signatures from respective organization's Admin user would be required on the  <CHANNEL_NAME>config_update_in_envelope.pb file before submission to the channel.

For obtaining these signatures a flag, `update_config.joiner_peer_sign` can be set to *true* in the respective channel under `network.channels` section in `network.yaml` file as

```yaml
network:
  ..
  ..
  # The channels defined for a network with participating peers in each channel
  channels:
  - channel:
    consortium: SupplyChainConsortium
    channel_name: AllChannel
    orderer: 
      name: supplychain
    participants:
    - organization:
      name: carrier
      type: creator       # creator organization will create the channel and instantiate chaincode, in addition to joining the channel and install chaincode
      org_status: new
      peers:
      - peer:
        name: peer0
        gossipAddress: peer0.carrier-net.org3ambassador.blockchaincloudpoc.com:8443  # External or internal URI of the gossip peer
        peerAddress: peer0.carrier-net.org3ambassador.blockchaincloudpoc.com:8443 # External URI of the peer
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:8443             # External or internal URI of the orderer
    - organization:      
      name: store
      type: joiner        # joiner organization will only join the channel and install chaincode
      org_status: new
      peers:
      - peer:
        name: peer0
        gossipAddress: peer0.store-net.org3ambassador.blockchaincloudpoc.com:8443
        peerAddress: peer0.store-net.org3ambassador.blockchaincloudpoc.com:8443 # External URI of the peer
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:8443
    - organization:
      name: warehouse
      type: joiner
      org_status: new
      peers:
      - peer:
        name: peer0
        gossipAddress: peer0.warehouse-net.org2ambassador.blockchaincloudpoc.com:8443
        peerAddress: peer0.warehouse-net.org3ambassador.blockchaincloudpoc.com:8443 # External URI of the peer
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:8443
    - organization:
      name: manufacturer
      type: joiner
      org_status: new
      peers:
      - peer:
        name: peer0
        gossipAddress: peer0.manufacturer-net.org2ambassador.blockchaincloudpoc.com:8443
        peerAddress: peer0.manufacturer-net.org3ambassador.blockchaincloudpoc.com:8443 # External URI of the peer
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:8443
    genesis:
      name: OrdererGenesis
    update_config:                        # Specify signature requirements for updating channel config | creator peer signature are done by default
        joiner_peer_sign: true              # For signatures from all joiner peers
        orderer_sign: true                  # For signatures from orderer

```

To submit this signed config see [Submit the envelope to channel](#submit_to_channel) section.

<a name = "sign_orderer"></a>
## Get signatures from Orderer (if required)
If the configuration has updates related to orderer organization, signatures from orderer organization's Admin user would be required on the  <CHANNEL_NAME>config_update_in_envelope.pb file before submission to the channel.

For obtaining these signatures a flag, `update_config.orderer_sign` can be set to *true* in the respective channel under `network.channels` section in `network.yaml` file as

```yaml
network:
  ..
  ..
  # The channels defined for a network with participating peers in each channel
  channels:
  - channel:
    consortium: SupplyChainConsortium
    channel_name: AllChannel
    orderer: 
      name: supplychain
    participants:
    - organization:
      name: carrier
      type: creator       # creator organization will create the channel and instantiate chaincode, in addition to joining the channel and install chaincode
      org_status: new
      peers:
      - peer:
        name: peer0
        gossipAddress: peer0.carrier-net.org3ambassador.blockchaincloudpoc.com:8443  # External or internal URI of the gossip peer
        peerAddress: peer0.carrier-net.org3ambassador.blockchaincloudpoc.com:8443 # External URI of the peer
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:8443             # External or internal URI of the orderer
    - organization:      
      name: store
      type: joiner        # joiner organization will only join the channel and install chaincode
      org_status: new
      peers:
      - peer:
        name: peer0
        gossipAddress: peer0.store-net.org3ambassador.blockchaincloudpoc.com:8443
        peerAddress: peer0.store-net.org3ambassador.blockchaincloudpoc.com:8443 # External URI of the peer
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:8443
    - organization:
      name: warehouse
      type: joiner
      org_status: new
      peers:
      - peer:
        name: peer0
        gossipAddress: peer0.warehouse-net.org2ambassador.blockchaincloudpoc.com:8443
        peerAddress: peer0.warehouse-net.org3ambassador.blockchaincloudpoc.com:8443 # External URI of the peer
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:8443
    - organization:
      name: manufacturer
      type: joiner
      org_status: new
      peers:
      - peer:
        name: peer0
        gossipAddress: peer0.manufacturer-net.org2ambassador.blockchaincloudpoc.com:8443
        peerAddress: peer0.manufacturer-net.org3ambassador.blockchaincloudpoc.com:8443 # External URI of the peer
      ordererAddress: orderer1.org1ambassador.blockchaincloudpoc.com:8443
    genesis:
      name: OrdererGenesis
    update_config:                        # Specify signature requirements for updating channel config | creator peer signature are done by default
        joiner_peer_sign: true              # For signatures from all joiner peers
        orderer_sign: true                  # For signatures from orderer

```

To submit this signed config see [Submit the envelope to channel](#submit_to_channel) section.

<a name = "submit_to_channel"></a>
## Submit the envelope to channel
The [sign-update-config-envelope.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/shared/configuration/sign-update-config-envelope.yaml) playbook can be used to submit the signed updated config block envelope for updating channel config. 

This playbook takes into account the `update_config.joiner_peer_sign` and `update_config.orderer_sign` flags to check what signatures are required to be obtained. \

This playbook can be executed using the following command

```
ansible-playbook platforms/shared/configuration/sign-update-config-envelope.yaml --extra-vars "@path-to-network.yaml"
```

For `network.yaml` reference, see `network-fabricv2.yaml` file [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/samples).

---
**NOTE:** Creator Peer Organization's Admin User signatures are done by default to the <CHANNEL_NAME>config_update_in_envelope.pb file.

