#! /bin/bash

# set hostname,hostmap and build cluster

echo -e " k8s-master \n k8s-node1 \n k8s-node2"
read -p "Choose your host name: " name

hostnamectl set-hostname $name

echo -e "192.168.137.151 k8s-master\n192.168.137.152 k8s-node1\n192.168.137.153 k8s-node2" >> /etc/hosts

hostname
tail -n 3 /etc/hosts

echo "hostname and hostmap Set Successful"
echo "Start pull k8s.abt, Please enter <password> after <yes>"
cd ;scp root@192.168.137.151:/root/k8s.abt .

#-- open forward--#
echo "1" > /proc/sys/net/ipv4/ip_forward
#-- open forward when reboot--#
echo "echo 1 > /proc/sys/net/ipv4/ip_forward" >> /etc/rc.d/rc.local

tail -n 2 k8s.abt | sh

# cp /etc/kubernetes/kubelet.conf $HOME/
# chown $(id -u):$(id -g) $HOME/kubelet.conf
# export KUBECONFIG=$HOME/kubelet.conf

echo "Please wait 20s"
sleep 20

kubectl get node;kubectl get pods --namespace=kube-system
echo "Set Successful"
