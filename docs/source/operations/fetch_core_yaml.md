<a name = "fetch-core-yaml"></a>
# Fetch core.yaml from running peer using BAF

The [fetch-peer-core-yaml.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/shared/configuration/fetch-peer-core-yaml.yaml) playbook can be used to fetch the existing config block for a channel. This can be done using the following command

```
ansible-playbook platforms/hyperledger-fabric/configuration/fetch-peer-core-yaml.yaml --extra-vars "@path-to-network.yaml"
```

The file is saved in the `build` folder as <PEER_NAME>-<ORG_NAME>-core.yaml

For `network.yaml` reference, see `network-fabricv2.yaml` file [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/samples).