cd /root/UAT/;kubectl apply -f kubernetes-dashboard.yaml
kubectl apply -f kube-dashboard-access.yaml

kubectl get pods --namespace=kube-system

echo -e "\e[36;1mAccess the Darshboard Using $(grep `hostname` /etc/hosts |awk '{print $1}'):30090\e[0m"
