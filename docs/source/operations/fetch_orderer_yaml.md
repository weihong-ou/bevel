<a name = "fetch-orderer-yaml"></a>
# Fetch orderer.yaml from running orderer using BAF

The [fetch-orderer-yaml.yaml](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/shared/configuration/fetch-orderer-yaml.yaml) playbook can be used to fetch the existing config block for a channel. This can be done using the following command

```
ansible-playbook platforms/hyperledger-fabric/configuration/fetch-orderer-yaml.yaml --extra-vars "@path-to-network.yaml"
```

The file is saved in the `build` folder as <ORDERER_NAME>-<ORG_NAME>-orderer.yaml

For `network.yaml` reference, see `network-fabricv2.yaml` file [here](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/samples).