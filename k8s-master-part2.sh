#! /bin/bash


# k8s-master-part2.sh
# master 节点安装

#----------以下为离线安装----------#

# flannel
(kubectl get node;kubectl get pods --namespace=kube-system) | tee $HOME/before 

kubectl apply -f $HOME/UAT/kube-flannel.yml

echo -e "\e[33;1mMaybe you have to wait a while to see the results you want.\e[0m"

(kubectl get node;kubectl get pods --namespace=kube-system) | tee $HOME/after
diff -y before after

echo "> Flannel: The installation is complete <"

# dashboard
cd /root/UAT/;kubectl apply -f kubernetes-dashboard.yaml
kubectl apply -f kube-dashboard-access.yaml

kubectl get pods --namespace=kube-system

echo -e "\e[36;1mAccess the Darshboard Using $(grep `hostname` /etc/hosts |awk '{print $1}'):30090\e[0m"

# helm
cd /root/UAT/;tar -zxvf helm-v2.11.0-linux-amd64.tar.gz;cp linux-amd64/helm /usr/local/bin/
kubectl create -f rbac-config.yaml
helm init --service-account tiller --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
helm version
echo -e '\e[36;1mHelm Installed Successful!\e[0m'

# EFK
cd /root/UAT/;tar -xvzf EFK.tar.gz -C .
cd /root/UAT/EFK/

kubectl apply -f es-deployment.yaml
kubectl apply -f es-service.yaml
kubectl apply -f fluentd-es-configmap.yaml
kubectl apply -f fluentd-es-ds.yaml
kubectl apply -f kibana-deployment.yaml
kubectl apply -f kibana-service.yaml

echo -e '\e[36;1mWait a moment, then try: \n> kubectl get po -n kube-system <\e[0m'
sleep 20

kubectl get po -n kube-system

echo -e "\e[36;1mElesticsearch:\t$(grep `hostname` /etc/hosts |awk '{print $1}'):$(kubectl get svc -n kube-system | grep "elastic" | grep -Eo "[0-9]{5}")\e[0m"
echo -e "\e[36;1mKibana:\t\t$(grep `hostname` /etc/hosts |awk '{print $1}'):$(kubectl get svc -n kube-system | grep "kibana" | grep -Eo "[0-9]{5}")\e[0m"

# prometheus
cd /root/UAT/;tar -xvzf prometheus.tar.gz -C .
cd /root/UAT/prometheus/;kubectl create namespace monitor

kubectl apply -f configmap.yaml 
kubectl apply -f grafana-deploy.yaml 
kubectl apply -f grafana-svc.yaml 
kubectl apply -f node-exporter.yaml 
kubectl apply -f prometheus.svc.yml 
kubectl apply -f prometheus.yaml
kubectl apply -f rbac-setup.yaml

echo -e '\e[36;1mWait a moment, then try: \n> kubectl get pods -n monitor <\e[0m'
sleep 20

kubectl get pods -n monitor

echo -e "\e[36;1mGrafana:\t$(grep `hostname` /etc/hosts |awk '{print $1}'):$(kubectl get svc -n monitor | grep "grafana" | grep -Eo "[0-9]{5}")\e[0m"
echo -e "\e[36;1mPrometheus:\t$(grep `hostname` /etc/hosts |awk '{print $1}'):$(kubectl get svc -n monitor | grep "prometheus" | grep -Eo "[0-9]{5}")\e[0m"
