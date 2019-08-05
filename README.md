# UAT
@startuml
title Container v1.0 实验流程\n
scale 1.8
'skinparam handwritten true

start
:创建虚拟机;
:配置系统环境;
-> Docker.sh;
:安装 Docker;
-> 克隆虚拟机;
split
  :Container;
split again
  :k8s;
  -> k8s.sh;
  :pre_Kubernetes;
  -> 克隆虚拟机;
  split 
    :k8s-master;
    -> k8s-master-part1.sh;
    :k8s-master-without packages;
    -> k8s-master-part2.sh;
    :Kubernetes-master;
  split again
    :k8s-node;
    -> 克隆虚拟机;
    #Pink:After k8s-master-part1.sh>
      split
        :k8s-node1;
        -> k8s-node.sh;
      split again
        :k8s-node2;
        -> k8s-node.sh;
      end split
      :Kubernetes Node;
      #Pink:Then k8s-master-part2.sh<
  end split
  :Kubernetes Cluster;
end split
stop
@enduml
