#! /bin/bash

cd /root/UAT/;tar -zxvf helm-v2.11.0-linux-amd64.tar.gz;cp linux-amd64/helm /usr/local/bin/
kubectl create -f rbac-config.yaml
helm init --service-account tiller --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
helm version
echo -e '\e[36;1mHelm Installed Successful!\e[0m'
