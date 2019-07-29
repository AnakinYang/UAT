#! /bin/bash

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
