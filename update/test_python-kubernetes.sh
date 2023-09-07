
confpath=$(dirname $0)
cp $confpath/config-pub /tmp/config-pub
export KUBECONFIG=/tmp/config-pub

cd $(dirname $0)
python3 test_python-kubernetes.py

#rm -f $KUBECONFIG

