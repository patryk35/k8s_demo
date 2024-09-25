#!/usr/bin/env bash

set -eufo pipefail

cat <<EOF > /tmp/metallb-tmp.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: config
  namespace: metallb-system
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - ${LOCAL_CLUSTER_IP}-${LOCAL_CLUSTER_IP}
EOF

minikube addons enable metallb
kubectl apply -f /tmp/metallb-tmp.yaml
kubectl -n metallb-system rollout restart daemonset speaker
kubectl -n metallb-system rollout restart deployment controller
