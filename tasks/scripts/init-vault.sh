#!/usr/bin/env bash

set -eufo pipefail
sleep 5

FIRST_POD=$(kubectl -n vault get pod -l app.kubernetes.io/name=vault -o=name | grep -E "*-0$")
kubectl exec -n vault ${FIRST_POD} -- vault status --format=json && echo "Vault already initiated and unsealed, skipping..." && exit 0

# cannot wait for `Ready`, cause it reach this state after unsealing
kubectl wait -n vault --timeout=360s --for=jsonpath='.status.phase'=Running pod -l app.kubernetes.io/name=vault
sleep 30

CLUSTER_KEY=$(kubectl exec -n vault ${FIRST_POD} -- /bin/sh -c "vault operator init -key-shares=1 -key-threshold=1 -format=json")
LOCAL_VAULT_UNSEAL_KEY=$(echo "$CLUSTER_KEY" | jq -r ".unseal_keys_b64[]")
LOCAL_VAULT_ROOT_TOKEN=$(echo "$CLUSTER_KEY" | jq -r ".root_token")

echo "LOCAL_VAULT_UNSEAL_KEY=$LOCAL_VAULT_UNSEAL_KEY" > .vault.secrets
echo "LOCAL_VAULT_ROOT_TOKEN=$LOCAL_VAULT_ROOT_TOKEN" >> .vault.secrets

#for more than 1 replica unseal should be run on all replicas https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-minikube-consul
for pod in $(kubectl -n vault get pod -l app.kubernetes.io/name=vault -o=name)
do
  kubectl exec -n vault $pod -- vault operator unseal $LOCAL_VAULT_UNSEAL_KEY
done

ADDONS_POLICY=$(cat <<-EOF
path "secret/local/data/*" {
  capabilities = ["read"]
}
EOF
)

kubectl exec -it -n vault vault-0 -- sh -c "echo '$LOCAL_VAULT_ROOT_TOKEN' | vault login --no-print -"
kubectl exec -it -n vault vault-0 -- sh -c "vault secrets enable -path=secret/local kv-v2"
kubectl exec -it -n vault vault-0 -- sh -c "vault auth enable kubernetes"
kubectl exec -it -n vault vault-0 -- sh -c 'vault write auth/kubernetes/config kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443"'
kubectl exec -it -n vault vault-0 -- sh -c "echo '$ADDONS_POLICY' > /tmp/policy.hcl && cat /tmp/policy.hcl | vault policy write external-secrets-addons - && rm /tmp/policy.hcl"
kubectl exec -it -n vault vault-0 -- sh -c "vault write auth/kubernetes/role/external-secrets-addons bound_service_account_names=external-secrets bound_service_account_namespaces=external-secrets policies=external-secrets-addons ttl=24h"
