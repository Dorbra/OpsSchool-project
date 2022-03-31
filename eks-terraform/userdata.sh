
aws eks update-kubeconfig --region us-east-1 --name dorbra-kandula-prod-23
kubectl create secret generic consul-gossip-encryption-key --from-literal=key="uDBV4e+LbFW3019YKPxIrg=="
echo "Kubectl apply dnsutils"
kubectl apply -f dnsutils.yaml

echo "Helm intalling consul..."
helm install consul hashicorp/consul -f values.yaml

CONSULIP=$(kubectl get svc consul-consul-dns | tail -1 |awk '{ print $3 }')
sed -i -e "s/CONSULIP/${CONSULIP}/g" configmap.yaml
echo "Kubectl apply configmap"
kubectl apply -f configmap.yaml
sed -i -e "s/${CONSULIP}/CONSULIP/g" configmap.yaml

# monitoring prometheus
echo "Helm installing kube-prometheus-stack"
helm install kube-prometheus prometheus-community/kube-prometheus-stack

# filebeat
echo "Kubectl apply filebeat"
kubectl apply -f filebeat.yaml
