#!/usr/bin/env bash

set -eufo pipefail

# TODO: skip if was previous step
now_zulu=$(date -u +%Y-%m-%dT%H:%M:%SZ)
kubectl exec -it -n vault vault-0 -- sh -c "echo '${LOCAL_VAULT_ROOT_TOKEN}' | vault login --no-print -"
kubectl exec -it -n vault vault-0 -- sh -c "vault kv put -mount=secret/local argocd-addons-repo-creds url='${LOCAL_ARGOCD_ADDONS_REPO}' sshPrivateKey='$(cat ${LOCAL_ARGOCD_ADDONS_REPO_SSH_KEY_LOCATION})' envName='${LOCAL_ARGOCD_ADDONS_ENV_NAME}'"
kubectl exec -it -n vault vault-0 -- sh -c "vault kv put -mount=secret/local argocd-secret adminPassword='${LOCAL_ARGOCD_ADMIN_PASSWORD_BCRYPT}' serverSecretKey='${LOCAL_ARGOCD_JWT_SECRET}' adminPasswordMTime='${now_zulu}' auth0ClientID='${LOCAL_ARGOCD_AUTH0_CLIENT_ID}' auth0ClientSecret='${LOCAL_ARGOCD_AUTH0_CLIENT_SECRET}'"
kubectl exec -it -n vault vault-0 -- sh -c "vault kv put -mount=secret/local argocd-slack-token slackToken='${LOCAL_ARGOCD_SLACK_OAUTH_TOKEN}'"



#kubectl exec -it -n vault vault-0 -- sh -c "rm -f /tmp/tmp.secret"
