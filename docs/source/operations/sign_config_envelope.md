<a name = "sign-channel-config"></a>
# Sign channel configuration using BAF

Once a Hyperledger Fabric network is up, using BAF, BAF users might want to get signatures to upadate certain channel configurations on the fly. BAF supports this task by executing the following steps:

 - [Get signatures from Joiner Peers](#sign_joiner_peers)
 - [Get signatures from Orderer](#sign_orderer)


<a name = "sign_joiner_peers"></a>
## Get signatures from Joiner Peers
If the configuration has updates related to joiner peer organizations, signatures from respective organization's Admin user would be required on the  <CHANNEL_NAME>_config_update_in_envelope.pb file before submission to the channel.

**NOTE:** The target config block envelope should be made available at `blockchain-automation-framework/build/` folder as <CHANNEL_NAME>_config_update_in_envelope.pb.

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
## Get signatures from Orderer
If the configuration has updates related to orderer organization, signatures from orderer organization's Admin user would be required on the  <CHANNEL_NAME>_config_update_in_envelope.pb file before submission to the channel.

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

The [sign-config-envelope.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/shared/configuration/sign-config-envelope.yaml) playbook can be used to get signed updated config block envelope for updating channel config. 

This playbook takes into account the `update_config.joiner_peer_sign` and `update_config.orderer_sign` flags to check what signatures are required to be obtained. \

This playbook can be executed using the following command

```
ansible-playbook platforms/shared/configuration/sign-config-envelope.yaml --extra-vars "@path-to-network.yaml"
```

For `network.yaml` reference, see `network-fabricv2.yaml` file [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/samples).

---
**NOTE:** Creator Peer Organization's Admin User signatures are done by default to the <CHANNEL_NAME>_config_update_in_envelope.pb file.
