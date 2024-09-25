# All Apps
TODO(high): How to keep it up-to-date? https://kubectl.docs.kubernetes.io/references/kustomize/builtins/#_helmchartinflationgenerator_
TODO(medium): Add Grafana/NewRelic dashboards
    https://raw.githubusercontent.com/aws/karpenter-provider-aws/v1.0.1/website/content/en/preview/getting-started/getting-started-with-karpenter/grafana-values.yaml
    https://raw.githubusercontent.com/external-secrets/external-secrets/main/docs/snippets/dashboard.json
    https://github.com/argoproj/argo-cd/blob/master/examples/dashboard.json
TODO(medium): Taints and Tollerations
TODO(high): kustomize --helm-kube-version
TODO: https://github.com/ahmetb/kubernetes-network-policy-recipes

# Security
TODO(high): enable NetworkPolicies for all apps ("deny all" / "permit by exception" approach for inbound and outbound network traffic.)
TODO(high): enforce NetworkPolicies validation
TODO(high): Monitoring privileges (use the least privileges)
TODO(high): Kyverno security policies to enforce secure configuration


# ExternalSecrets
TODO(high): Kyverno rules to validate 
- ExternalSecret name must contains namespace name
- ExternalSecret in specific namespace can use only listed providers
- 
TODO(high): ExternalSecrets ClusterSecretStore connection to vault using https
TODO (low): consider using cert-manager for ExternalSecrets certManager

# ArgoCD
TODO(high): NetworkPolicy blocks metrics assess
TODO(low): auth scopes for Auth0 https://argocd.sirius/groups
TODO(low): move images and tars to own repos
TODO(low): open telemetry
TODO(low): GitHub webhook handling
TODO(low): https://argo-cd.readthedocs.io/en/stable/user-guide/gpg-verification/


# Calico
TODO(medium): for local/etc. use repo configuration, not minikube plugin 

# Application configuration checklist -> policies

1. TopologySpreadConstraints set
2. Namespace with the least possible PSA
3. NetworkPolicy applied
4. Pod security configuration as strict as possible, e.g. ro root file system


# Logs
https://www.mailslurp.com/blog/fluentbit-kubernetes-exclude-pod-namespace-eks/