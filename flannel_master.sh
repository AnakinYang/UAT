#! /bin/bash

(kubectl get node;kubectl get pods --namespace=kube-system) | tee $HOME/before 

cd ;wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f ~/kube-flannel.yml


echo "Wait a moment"
sleep 100

(kubectl get node;kubectl get pods --namespace=kube-system) | tee $HOME/after
diff -y before after

echo "> Flannel: The installation is complete <"
