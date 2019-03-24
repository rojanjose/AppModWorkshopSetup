#!/bin/bash
#Script to create cluster in a batch

ZONE="wdc07"
KUBE_VERSION="1.12.6"
MACHINE_TYPE="u2c.2x4"
WORKER_NODE_COUNT=2
HARDWARE="shared"
PRIVATE_VLAN=2573695
PUBLIC_VLAN=2573693

CLUSTER_RANGE=$1;
CSTART=$(cut -d'-' -f1 <<< $CLUSTER_RANGE);
CEND="$(cut -d'-' -f2 <<< $CLUSTER_RANGE)";

#for num in `seq -w $CSTART $CEND`; 
for num in `seq -f "%03g" $CSTART $CEND`; 
do 

CLUSTER_NAME="user$num-cluster"
echo "Creating cluster $CLUSTER_NAME ..."
echo "ibmcloud ks cluster-create --name $CLUSTER_NAME --kube-version $KUBE_VERSION --zone $ZONE --machine-type $MACHINE_TYPE --workers $WORKER_NODE_COUNT --hardware $HARDWARE --private-vlan $PRIVATE_VLAN --public-vlan $PUBLIC_VLAN"
ibmcloud ks cluster-create --name $CLUSTER_NAME --kube-version $KUBE_VERSION --zone $ZONE --machine-type $MACHINE_TYPE --workers $WORKER_NODE_COUNT --hardware $HARDWARE --private-vlan $PRIVATE_VLAN --public-vlan $PUBLIC_VLAN

done

