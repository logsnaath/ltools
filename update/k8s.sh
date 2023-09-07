#set -x

echo_line () {
  echo "======================="
  echo;
}

confpath=$(dirname $0)
cp $confpath/config-pub /tmp/config-pub

nginx_podname=nginx-$(hostname)
realpath `which kubectl`
echo_line;

export KUBECONFIG=/tmp/config-pub
kubectl version
echo_line;

kubectl get -owide no,ns
kubectl get -owide svc,po
echo_line;

kubectl cluster-info
echo_line;

kubectl delete po ${nginx_podname}
echo_line;

kubectl run ${nginx_podname} --image=nginx
echo_line;

kubectl get po -owide
echo_line;
sleep 10

kubectl get po -owide
echo_line;

kubectl delete po ${nginx_podname}
echo_line;

kubectl api-resources

#rm -f $KUBECONFIG

