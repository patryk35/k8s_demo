#!/usr/bin/env bash

set -eufo pipefail

sleep 5
kubectl wait -n vault --for=jsonpath='.status.phase'=Running pod -l app.kubernetes.io/name=vault
sleep 5

#for more than 1 replica unseal should be run on all replicas https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-minikube-consul
for pod in $(kubectl -n vault get pod -l app.kubernetes.io/name=vault -o=name)
do
  kubectl exec -n vault $pod -- vault operator unseal $LOCAL_VAULT_UNSEAL_KEY
done