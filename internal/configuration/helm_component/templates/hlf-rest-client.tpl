apiVersion: flux.weave.works/v1beta1
kind: HelmRelease
metadata:
  name: {{ name }}-hlf-rest-client
  namespace: {{ component_ns }}
  annotations:
    flux.weave.works/automated: "false"
spec:
  chart:
    path: {{ component_gitops.chart_source }}/hlf-rest-client
    git: {{ component_gitops.git_ssh }}
    ref: {{ component_gitops.branch }}
  releaseName: {{ name }}-hlf-rest-client
  values:
    metadata:
      namespace: {{ component_ns }}
    app:
      name: {{ name }}-hlf-rest-client
      port: {{ peer_restserver_port }}
      image: {{ network.docker.url }}/supplychain_fabric:rest_server_latest
    server:
      localmspid: {{ name }}MSP
    vault:
      address: {{ component_vault.url }}
      role: vault-role
      authpath: {{ component_ns }}-auth
      secretprefix: secret/crypto/peerOrganizations/{{ component_ns }}
      serviceaccountname: vault-auth
      imagesecretname: regcred
      image: hyperledgerlabs/alpine-utils:1.0
    service:
      type: ClusterIP
      ports:
        apiPort: {{ peer_restserver_targetport }}
        targetPort: 8000
    connection:
      peer: {{ peer_name }}.{{ component_ns }}
      peerAddress: {{ peer_url.split(':')[0] }}
      peerPort: {{ peer_url.split(':')[1] }}
      ordererAddress: {{ orderer_url.split(':')[0] }}
      ordererPort: {{ orderer_url.split(':')[1] }}
