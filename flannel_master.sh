#! /bin/bash

(kubectl get node | tee before;kubectl get pods --namespace=kube-system) | tee before 

cd ;wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f ~/kube-flannel.yml


echo "Wait a moment"
sleep 100

(kubectl get node | tee before;kubectl get pods --namespace=kube-system) | tee after
diff -y before after

echo "> Flannel: The installation is complete <"
