#!/bin/bash

HARDWARE="${HARDWARE:-shared}"
KUBE_VERSION="${KUBE_VERSION:-1.16.7}"
MACHINE_TYPE="${MACHINE_TYPE:-b3c.4x16}"
PRIVATE_VLAN="${PRIVATE_VLAN:-2573695}"
PUBLIC_VLAN="${PUBLIC_VLAN:-2573693}"
WORKER_NODE_COUNT="${WORKER_NODE_COUNT:-2}"
ZONE="${ZONE:-wdc07}"

print_help(){
cat << EOF
Usage: $0 [OPTIONS]...

Create clusters.

Mandatory arguments to long options are mandatory for short options too.
  -r=,  --cluster-range=NUM1-NUM2    range from NUM1 to NUM2 for cluster numbers
  -hw=, --hardware=STRING            hardware configuration for k8s;
                                         defaults to shared
      --kube-version=NUM             k8s version to install;
                                         defaults to 1.12.6
  -t=,  --machine-type=STRING        STRING machine configuration;
                                         defaults to b3c.4x16
      --private-vlan=NUM             use private vlan identified by NUM;
                                         defaults to 2573695
      --public-vlan=NUM              use public vlan identified by NUM;
                                         defaults to 2573693
  -c=,  --worker-node-count=NUM      NUM workers in cluster;
                                         defaults to 2
  -z=,  --zone=STRING                host clusters in STRING availabilty zone;
                                         defaults to wdc07
  -h   --help                        display this help and exit

EOF
}

for OPT in "$@"; do
    case "$OPT" in
        -r=*|--cluster-range=*)
            CLUSTER_RANGE="${OPT#*=}"
            ;;
        -hw=*|--hardware=*)
            HARDWARE="${OPT#*=}"
            ;;
        --kube-version=*)
            KUBE_VERSION="${OPT#*=}"
            ;;
        -t=*|--machine-type=*)
            MACHINE_TYPE="${OPT#*=}"
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
        -h|--help)
            print_help
            exit 0
            ;;
        *)
            echo "Unexpected flag $OPT"
            print_help
            exit 2
            ;;
    esac
done

if [[ -z $CLUSTER_RANGE ]]; then
    echo "Error: cluster range required."
    print_help
    exit 3
fi

CSTART=$(cut -d'-' -f1 <<< "$CLUSTER_RANGE")
CEND=$(cut -d'-' -f2 <<< "$CLUSTER_RANGE")

for num in $(seq -f "%03g" "$CSTART" "$CEND"); do
    CLUSTER_NAME="user$num-cluster"
    echo "Creating cluster $CLUSTER_NAME ..."
    echo "ibmcloud ks cluster-create --name $CLUSTER_NAME --kube-version $KUBE_VERSION --zone $ZONE --machine-type $MACHINE_TYPE --workers $WORKER_NODE_COUNT --hardware $HARDWARE --private-vlan $PRIVATE_VLAN --public-vlan $PUBLIC_VLAN"
    ibmcloud ks cluster-create --name "$CLUSTER_NAME" --kube-version "$KUBE_VERSION" --zone "$ZONE" --machine-type "$MACHINE_TYPE" --workers "$WORKER_NODE_COUNT" --hardware "$HARDWARE" --private-vlan "$PRIVATE_VLAN" --public-vlan "$PUBLIC_VLAN"
done
