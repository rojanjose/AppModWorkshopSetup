#!/bin/bash
#Script to delete clusters in a batch

CLUSTER_RANGE=$1;
CSTART=$(cut -d'-' -f1 <<< $CLUSTER_RANGE);
CEND="$(cut -d'-' -f2 <<< $CLUSTER_RANGE)";

for num in `seq -f "%03g" $CSTART $CEND`; 
do 

CLUSTER_NAME="user$num-cluster"
echo "Deleteing cluster $CLUSTER_NAME ..."
ibmcloud ks cluster-rm --cluster $CLUSTER_NAME -f --force-delete-storage

done

