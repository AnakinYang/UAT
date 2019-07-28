#! /bin/bash

(kubectl get node;kubectl get pods --namespace=kube-system) | tee $HOME/before 

cd ;wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f ~/kube-flannel.yml


echo -e "\e[33;1mMaybe you have to wait a while to see the results you want.\e[0m"

(kubectl get node;kubectl get pods --namespace=kube-system) | tee $HOME/after
diff -y before after

echo "> Flannel: The installation is complete <"
