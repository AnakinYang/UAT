#! /bin/bash
# Docker setup
yum -y install curl
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.myhuaweicloud.com/repo/CentOS-Base-7.repo
yum makecache

yum -y install yum-utils device-mapper-persistent-data lvm2
rpm -qa | grep yum-utils
rpm -qa | grep device-mapper-persistent-data
rpm -qa | grep lvm2

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum -y install docker-ce-18.06.2.ce

systemctl start docker
systemctl enable docker
systemctl status docker | grep "active"

curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
echo "Set Docker source successful"

echo "Congratulations, this host has successfully deployed docker."
