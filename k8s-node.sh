#! /bin/bash

# k8s-node.sh
# k8s 节点设置

# 完成k8s子节点设置，不用联网

#-------------------网络设置---------------------#
read -p "Enter master's name: " name
read -p "Enter master's IP: " IP

read -p "Enter node1's name(1/2): " name1
read -p "Enter node1's IP(1/2): " IP1

read -p "Enter node2's name(2/2): " name2
read -p "Enter node2's IP(2/2): " IP2

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

#----------子节点设置（flannel 之后）----------#
echo "Start pull k8s.abt, Please enter <password> after <yes>"
cd ;scp root@$IP:/root/k8s.abt .

#-- open forward--#
echo "1" > /proc/sys/net/ipv4/ip_forward
#-- open forward when reboot--#
echo "echo 1 > /proc/sys/net/ipv4/ip_forward" >> /etc/rc.d/rc.local

tail -n 2 k8s.abt | sh

echo "Please wait 20s"
sleep 20

kubectl get node;kubectl get pods --namespace=kube-system
echo "Set Successful"
#----------子节点设置---------#
