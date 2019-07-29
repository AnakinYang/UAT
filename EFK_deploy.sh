#! /bin/bash

cd /root/UAT/;tar -xvzf EFK.tar.gz -C .
cd /root/UAT/EFK/

#-- Set For Kibana --#
docker pull oceancloud/kibana-oss:v6.6.1
docker tag oceancloud/kibana-oss:v6.6.1 docker.elastic.co/kibana/kibana-oss:6.6.1


kubectl apply -f es-deployment.yaml
kubectl apply -f es-service.yaml
kubectl apply -f fluentd-es-configmap.yaml
kubectl apply -f fluentd-es-ds.yaml
kubectl apply -f kibana-deployment.yaml
kubectl apply -f kibana-service.yaml

echo -e '\e[36;1mWait a moment, then try: \n> kubectl get po -n kube-system <\e[0m'
sleep 20

kubectl get po -n kube-system

echo -e "\e[36;1mElesticsearch:\t$(grep `hostname` /etc/hosts |awk '{print $1}'):$(kubectl get svc -n kube-system | grep "elastic" | grep -Eo "[1-9]{5}")\e[0m"
echo -e "\e[36;1mKibana:\t\t$(grep `hostname` /etc/hosts |awk '{print $1}'):$(kubectl get svc -n kube-system | grep "kibana" | grep -Eo "[1-9]{5}")\e[0m"
