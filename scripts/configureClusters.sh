#!/bin/bash

CLUSTER_RANGE=$1;
CSTART=$(cut -d'-' -f1 <<< "$CLUSTER_RANGE");
CEND=$(cut -d'-' -f2 <<< "$CLUSTER_RANGE");

for num in $(seq -f "%03g" "$CSTART" "$CEND"); do
    CLUSTER_NAME="user$num-cluster"
    echo "Configuring cluster $CLUSTER_NAME ..."

    eval $(ibmcloud ks cluster-config --cluster "$CLUSTER_NAME" --export)
    kubectl apply -f https://raw.githubusercontent.com/IBM-Cloud/kube-samples/master/rbac/serviceaccount-tiller.yaml
    helm init --service-account tiller

    # set up istio
    yes | ibmcloud ks cluster-addon-enable istio-extras --cluster "$CLUSTER_NAME"
done
