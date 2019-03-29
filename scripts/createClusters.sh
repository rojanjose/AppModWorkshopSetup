#!/bin/bash

HARDWARE="${HARDWARE:-shared}"
KUBE_VERSION="${KUBE_VERSION:-1.12.6}"
MACHINE_TYPE="${MACHINE_TYPE:-u2c.2x4}"
PRIVATE_VLAN="${PRIVATE_VLAN:-2573695}"
PUBLIC_VLAN="${PUBLIC_VLAN:-2573693}"
WORKER_NODE_COUNT="${WORKER_NODE_COUNT:-2}"
ZONE="${ZONE:-wdc07}"

for OPT in "$@"; do
    case "$OPT" in
        -r=*|--cluster-range=*)
            CLUSTER_RANGE="${OPT#*=}"
            ;;
        -h=*|--hardware=*)
            HARDWARE="${OPT#*=}"
            ;;
        -t=*|--kube-version=*)
            KUBE_VERSION="${OPT#*=}"
            ;;
        --private-vlan=*)
            PRIVATE_VLAN="${OPT#*=}"
            ;;
        --public-vlan=*)
            PUBLIC_VLAN="${OPT#*=}"
            ;;
        -c=*|--worker-node-count=*)
            WORKER_NODE_COUNT="${OPT#*=}"
            ;;
        -z=*|--zone=*)
            ZONE="${OPT#*=}"
            ;;
        *)
            echo "Unexpected flag $OPT"
            exit 2
            ;;
    esac
done

if [[ -z $CLUSTER_RANGE ]]; then
    echo "Error: cluster range required..."
    echo "Set it with --cluster-range=1-50...or whatever your range is..."
    exit 2
fi

CSTART=$(cut -d'-' -f1 <<< "$CLUSTER_RANGE")
CEND=$(cut -d'-' -f2 <<< "$CLUSTER_RANGE")

for num in $(seq -f "%03g" "$CSTART" "$CEND"); do
    CLUSTER_NAME="user$num-cluster"
    echo "Creating cluster $CLUSTER_NAME ..."
    echo "ibmcloud ks cluster-create --name $CLUSTER_NAME --kube-version $KUBE_VERSION --zone $ZONE --machine-type $MACHINE_TYPE --workers $WORKER_NODE_COUNT --hardware $HARDWARE --private-vlan $PRIVATE_VLAN --public-vlan $PUBLIC_VLAN"
    ibmcloud ks cluster-create --name "$CLUSTER_NAME" --kube-version "$KUBE_VERSION" --zone "$ZONE" --machine-type "$MACHINE_TYPE" --workers "$WORKER_NODE_COUNT" --hardware "$HARDWARE" --private-vlan "$PRIVATE_VLAN" --public-vlan "$PUBLIC_VLAN"
done
