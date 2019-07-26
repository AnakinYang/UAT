#! /bin/bash
# Docker setup
yum -y install curl
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.myhuaweicloud.com/repo/CentOS-Base-7.repo
yum makecache

yum install -y yum-utils device-mapper-persistent-data lvm2
rpm -qa | grep yum-utils
rpm -qa | grep device-mapper-persistent-data
rpm -qa | grep lvm2
echo "you will see the yum-utils, grep device-mapper-persistent-data and lvm2 in above line"

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
echo "set yum source"


yum -y install docker-ce-18.06.2.ce

systemctl start docker
systemctl enable docker
systemctl status docker | grep "active"
echo "The active means docker install complete"



curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
echo "Set Docker source successful"


echo "Congratulations, this host has successfully deployed docker."
