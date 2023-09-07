#set -x

cd $(dirname $0)
exec_cmd() {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  echo;
}

confpath=$(dirname $0)
exec_cmd cp $confpath/config-pub /tmp/config-pub

nginx_podname=nginx-$(hostname)
realpath `which kubectl`

export KUBECONFIG=/tmp/config-pub
exec_cmd kubectl version

exec_cmd kubectl get -owide no,ns
exec_cmd kubectl get -owide svc,po
exec_cmd kubectl cluster-info
exec_cmd kubectl delete po ${nginx_podname}
exec_cmd kubectl run ${nginx_podname} --image=nginx
exec_cmd kubectl get po -owide

sleep 15
exec_cmd kubectl get po -owide

exec_cmd kubectl delete po ${nginx_podname}
exec_cmd kubectl api-resources

#rm -f $KUBECONFIG

