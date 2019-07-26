#! /bin/bash
# Docker setup

yum install -y yum-utils device-mapper-persistent-data lvm2
rpm -qa | grep yum-utils
rpm -qa | grep device-mapper-persistent-data
rpm -qa | grep lvm2
echo "you will see the yum-utils, grep device-mapper-persistent-data and lvm2 in above line"

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
echo "set yum source"

# set yum
sed -i 's|plugins=1|plugins=0|' /etc/yum.conf
sed -i 's|enabled=1|enabled=0|' /etc/yum/pluginconf.d/fastestmirror.conf
yum clean dbcache


curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
echo "Set Docker source successful"

yum –y install docker-ce-18.06.2.ce
systemctl start docker
systemctl enable docker
systemctl status docker | grep "active"
echo "The active means docker install complete"


echo "Congratulations, this host has successfully deployed docker."
