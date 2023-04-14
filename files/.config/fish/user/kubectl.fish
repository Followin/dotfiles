#kubectl completion fish | source

# configs
set default_config "$HOME/.kube/config"
if test $default_config
  set -x KUBECONFIG $default_config
end

for file in $HOME/.kube/config-files/*.{yml, yaml}
  set -x KUBECONFIG "$file:$KUBECONFIG"
end

abbr k kubectl

abbr kgp "kubectl get pod"
abbr kgs "kubectl get service"
abbr kgi "kubectl get ingress"
abbr kgd "kubectl get deploy"
abbr kgcm "kubectl get configmap"

abbr kdp "kubectl describe pods"
abbr kds "kubectl describe service"
abbr kdi "kubectl describe ingress"
abbr kdd "kubectl describe deploy"
abbr kdcm "kubectl describe configmap"

abbr kccc "kubectl config current-context"
abbr kcgc "kubectl config get-contexts"
abbr kcn "kubectl config set-context --current --namespace"
abbr kcuc "kubectl config use-context"

abbr kpf "kubectl port-forward"
abbr krrd "kubectl rollout restart deploy"
abbr ksd "kubectl scale deploy"

abbr kdelp "kubectl delete pod"
abbr kdeld "kubectl delete deploy"
abbr kdelcm "kubectl delete configmap"
abbr kdels "kubectl delete service"

abbr kge "kubectl get events"
abbr kgep "kubectl get events --field-selector involvedObject.kind=Pod,involvedObject.name="
abbr kged "kubectl get events --field-selector involvedObject.kind=Deployment,involvedObject.name="
