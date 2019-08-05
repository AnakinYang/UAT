#! /bin/bash

# k8s-master-part1
# 完成k8s主节点的安装包拉取，需联网

# k8s 环境初始化
systemctl stop firewalld
systemctl disable firewalld

swapoff -a 
sed -i 's/.*swap.*/#&/' /etc/fstab

modprobe br_netfilter

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl -p /etc/sysctl.d/k8s.conf

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.huaweicloud.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.huaweicloud.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.huaweicloud.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum -y install epel-release
yum -y install yum-utils device-mapper-persistent-data lvm2 net-tools  conntrack-tools wget vim  ntpdate libseccomp libtool-ltdl

systemctl enable ntpdate.service
echo '*/30 * * * * /usr/sbin/ntpdate time7.aliyun.com >/dev/null 2>&1' > /tmp/crontab2.tmp
crontab /tmp/crontab2.tmp
systemctl start ntpdate.service

systemctl daemon-reload
systemctl restart docker
systemctl enable docker
systemctl status docker

images=(
    kube-apiserver:v1.14.1
    kube-controller-manager:v1.14.1
    kube-scheduler:v1.14.1
    kube-proxy:v1.14.1
    pause:3.1
    etcd:3.3.10
    coredns:1.3.1
    flannel:v0.11.0-amd64
    tiller:v2.11.0
)
a=0
for imageName in ${images[@]} ; do
docker pull oceancloud/$imageName
let a++
if [ "$a" -ne 8 ] ; then
   docker tag oceancloud/$imageName k8s.gcr.io/$imageName
else
   docker tag oceancloud/$imageName quay.io/coreos/$imageName
fi
done

yum install -y kubelet-1.14.1-0.x86_64
yum install -y kubeadm-1.14.1-0.x86_64
yum install -y kubectl-1.14.1-0.x86_64
systemctl enable kubelet


#-------------------网络设置---------------------#
read -p "Enter this host's name: " name
read -p "Enter this host's IP: " IP

read -p "Enter othre host's name(1/2): " name1
read -p "Enter the IP of the host you just set(1/2): " IP1

read -p "Enter this host's name(2/2): " name2
read -p "Enter the IP of the host you just set(2/2): " IP2

read -p "Enter your Gateway: " gateway
read -p "Enter your Netmask: " netmask

hostnamectl set-hostname $name

#/etc/sysconfig/network-scripts/ifcfg-eth0
echo -e "
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=eth0
UUID=b69cd38f-7d48-4560-86c1-6cf11f75eb79
DEVICE=eth0
ONBOOT=yes
IPADDR=$IP
NETMASK=$netmask
GATEWAY=$gateway
DNS1=114.114.114.114" > /etc/sysconfig/network-scripts/ifcfg-eth0

#/etc/hosts
echo -e "
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
$name\t$IP
$name1\t$IP1
$name2\t$IP2
" > /etc/hosts

# 展示网络配置
hostname
cat /etc
tail -n 3 /etc/hosts
echo ">hostname and hostmap Set Successful<"
#----------网络设置---------------------------#

#----------------------k8s-master 设置--------------------#
yum install -y bash-completion
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)		
echo "source <(kubectl completion bash)" >> ~/.bashrc

kubeadm config images list

kubeadm init --pod-network-cidr=10.244.0.0/16 | tee $HOME/k8s.abt

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
