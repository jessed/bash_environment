# Kubernetes aliases and environment variables

##
## Environment variables
export kdc="--dry-run=client -o yaml"
export kds="--dry-run=server -o yaml"

##
## Kubernetes
alias k="kubectl"
alias kg="kubectl get"
alias ka="kubectl apply"
alias kc="kubectl create"
alias kd="kubectl delete"
alias kgp="kubectl get pods"
alias kgs="kubectl get service"
alias kgn="kubectl get nodes"
alias kdesc="kubectl describe"
alias kcuc="kubectl config use-context"


# stop processing on nodes that don't have a ~/.kube/config
if [[ ! -f $HOME/.kube/config ]]; then return; fi

# set KUBECONFIG environment variable
export KUBECONFIG=$HOME/.kube/config

# set k8s namespace
alias kcn="k config set-context $(kubectl config current-context) --namespace"

# kubevirt alias
alias virtctl="kubectl virt --kubeconfig=$KUBECONFIG"

# crtctl
if [[ -f unix:///run/containerd/containerd.sock ]]; then
  alias crictl="crictl -r unix:///run/containerd/containerd.sock"
fi


##
## Functions

k_login() {
  p=$1    # pod
  c=$2    # container
  n=$3    # namespace

  # define initial command
  cmd="kubectl exec -it $p"
  
  # Find namespace if not provided
  if [[ -z $n ]]; then
    n=$(kubectl get pod --all-namespaces | awk '/'$p'/ { print $1 }')
    cmd="$cmd -n $n"
  fi

  # if defined, add container identifier
  if [[ -n $c ]]; then cmd="$cmd $p -c $c"; fi

  # Add actual command to be executed
  cmd_exec="$cmd -- /bin/bash"

  echo $cmd_exec
  $cmd_exec 2>/dev/null

  # if running bash fails try again with sh
  if [[ $? != 0 ]]; then
    #echo -e "/bin/bah failed, trying again with /bin/sh\n"
    cmd_exec="$cmd -- /bin/sh"
    echo $cmd_exec
    $cmd_exec
  fi
}


k_nodes() {
	#columns='Hostname:.metadata.labels.kubernetes.io/hostname'
	#columns=${columns}',Name:.metadata.name'
  columns=""
	columns=${columns}'Name:.metadata.name'
	columns=${columns}',Role:.metadata.labels.role'
	columns=${columns}',Kubelet:.status.nodeInfo.kubeletVersion'
	columns=${columns}',Status:.status.conditions[-1].reason'
	columns=${columns}',CpuCores:.status.capacity.cpu'
	columns=${columns}',Ram:.status.capacity.memory'
  columns=${columns}',Address:.status.addresses[0].address'
  columns=${columns}',PodCidr:.spec.podCIDR'
	#columns=${columns}',Taints:.spec.taints'

	kubectl get nodes -o custom-columns=$columns
}
