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

#--for k8s-master--#
yum install -y bash-completion
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)		
echo "source <(kubectl completion bash)" >> ~/.bashrc

kubeadm config images list

# kubeadm init --pod-network-cidr=10.244.0.0/16
kubeadm init --pod-network-cidr=10.244.0.0/16 | tee k8s.abt

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#--Judgment initialization--#
# || kubeadm reset –f

echo "> initialization finished <"
