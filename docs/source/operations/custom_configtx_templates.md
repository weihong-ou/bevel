<a name = "custom-configtx-templates"></a>
# Use custom templates to generate configtx.yaml file using BAF

In BAF, configtx.yaml gets generated on the fly using the configuration values provided in the `network.yaml` and 4 default templates which corresponds to 4 sections of the configtx.yaml, namely:

 - *Init Section:* Corresponds to details related to Application, Capability and Channel defaults. Template File: [configtxinit_default.tpl](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/roles/create/configtx/templates/configtxinit_default.tpl)
 - *Orderer Section:* Corresponds to details related to Orderer. Template File: [configtxOrderer_default.tpl](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/roles/create/configtx/templates/configtxOrderer_default.tpl)
 - *Org Section:* Corresponds to details related to organizations. Template File: [configtxOrg_default.tpl](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/roles/create/configtx/templates/configtxOrg_default.tpl)
 - *Profile Section:* Corresponds to details related to Channel Profile, consortium et. al. Template File: [configtxProfile_default.tpl](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/roles/create/configtx/templates/configtxProfile_default.tpl)


BAF Users might want to use different/updated templates, rather than using default templates, depending on their network requirements. Such custom templates can be provided to BAF as input.

These custom templates can include the following changes/updates:

 - Updates in hardcoded values such as Policies.Rule, MaxMessageCount, BatchTimeout etc.
   E.g.:

    Default Template:

  ```yaml
      Orderer: &OrdererDefaults
    {% if consensus.name == 'raft' %}
      OrdererType: etcdraft
    {% else %}
      OrdererType: {{ consensus.name }}
    {% endif %}
      Addresses:
    {% for orderer in orderers %}
    {% if provider == 'minikube' %}
        - {{orderer.name}}.{{ component_ns }}:7050
    {% else %}
        - {{orderer.name}}.{{ item.external_url_suffix }}:8443
    {% endif %}
    {% endfor %}

      BatchTimeout: 2s
      BatchSize:
        MaxMessageCount: 10
        AbsoluteMaxBytes: 98 MB
        PreferredMaxBytes: 1024 KB
    {% if consensus.name == 'kafka' %}
      Kafka:
        Brokers:
    {% for i in range(consensus.replicas) %}
          - {{ consensus.name }}-{{ i }}.{{ consensus.type }}.{{ component_ns }}.svc.cluster.local:{{ consensus.grpc.port }}
    {% endfor %}
    {% endif %}
    {% if consensus.name == 'raft' %}
      EtcdRaft:
        Consenters:
    {% for orderer in orderers %}
          - Host: {{ orderer.name }}.{{ item.external_url_suffix }}
            Port: 8443
            ClientTLSCert: ./crypto-config/ordererOrganizations/{{ component_ns }}/orderers/{{ orderer.name }}.{{ component_ns }}/tls/server.crt
            ServerTLSCert: ./crypto-config/ordererOrganizations/{{ component_ns }}/orderers/{{ orderer.name }}.{{ component_ns }}/tls/server.crt
    {% endfor %}
    {% endif %}
      Organizations:
      Policies:
        Readers:
          Type: ImplicitMeta
          Rule: "ANY Readers"
        Writers:
          Type: ImplicitMeta
          Rule: "ANY Writers"
        Admins:
          Type: ImplicitMeta
          Rule: "MAJORITY Admins"
        BlockValidation:
          Type: ImplicitMeta
          Rule: "ANY Writers"
      Capabilities:
        <<: *OrdererCapabilities

  ```

   Custom Template (BatchTimeout,MaxMessageCount,Organizations.Policies):

  ```yaml
      Orderer: &OrdererDefaults
    {% if consensus.name == 'raft' %}
      OrdererType: etcdraft
    {% else %}
      OrdererType: {{ consensus.name }}
    {% endif %}
      Addresses:
    {% for orderer in orderers %}
    {% if provider == 'minikube' %}
        - {{orderer.name}}.{{ component_ns }}:7050
    {% else %}
        - {{orderer.name}}.{{ item.external_url_suffix }}:8443
    {% endif %}
    {% endfor %}

      BatchTimeout: 10s
      BatchSize:
        MaxMessageCount: 20
        AbsoluteMaxBytes: 98 MB
        PreferredMaxBytes: 1024 KB
    {% if consensus.name == 'kafka' %}
      Kafka:
        Brokers:
    {% for i in range(consensus.replicas) %}
          - {{ consensus.name }}-{{ i }}.{{ consensus.type }}.{{ component_ns }}.svc.cluster.local:{{ consensus.grpc.port }}
    {% endfor %}
    {% endif %}
    {% if consensus.name == 'raft' %}
      EtcdRaft:
        Consenters:
    {% for orderer in orderers %}
          - Host: {{ orderer.name }}.{{ item.external_url_suffix }}
            Port: 8443
            ClientTLSCert: ./crypto-config/ordererOrganizations/{{ component_ns }}/orderers/{{ orderer.name }}.{{ component_ns }}/tls/server.crt
            ServerTLSCert: ./crypto-config/ordererOrganizations/{{ component_ns }}/orderers/{{ orderer.name }}.{{ component_ns }}/tls/server.crt
    {% endfor %}
    {% endif %}
      Organizations:
      Policies:
        Readers:
          Type: ImplicitMeta
          Rule: "MAJORITY Readers"
        Writers:
          Type: ImplicitMeta
          Rule: "MAJORITY Writers"
        Admins:
          Type: ImplicitMeta
          Rule: "MAJORITY Admins"
        BlockValidation:
          Type: ImplicitMeta
          Rule: "MAJORITY Writers"
      Capabilities:
        <<: *OrdererCapabilities

  ```

These custom templates must be named accordingly and kept inside a same folder. Users can choose to customize any number of templates, there is no requirement for providing all 4 templates:

 - *Init Section:* configtxinit_custom.tpl
 - *Orderer Section:* configtxOrderer_custom.tpl
 - *Org Section:* configtxOrg_custom.tpl
 - *Profile Section:* configtxProfile_custom.tpl

The absolute path to the folder containing these custom templates can then be provided to the `network.yaml` in the `configtx` section with `configtx.custom` as TRUE.
```yaml
  # For providing Custom Templates to generate configtx.yaml
  configtx:
    custom: true               # true : when custom tpl(s) are to be provided | false : when the default tpl(s) are to be used
    folder_path: /absolute/path/to/folder             # path to folder where the tpl(s) are placed e.g. /home/blockchain-automation-framework/build/configtx_tpl/ 

```

This folder can be kept either outside the BAF project's root folder or in any `build/` folder inside the BAF Project.

Refer [this guide](./fabric_networkyaml.md) for details on editing the configuration file.

Refer [this sample](https://github.com/hyperledger-labs/blockchain-automation-framework/tree/develop/platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml) for details on the configuration file.

---
**NOTE**: Using custom templates to generate configtx.yaml file using BAF has been tested on network which is created by BAF. Networks created using other methods may be suitable but this has not been tested by BAF team.

---
