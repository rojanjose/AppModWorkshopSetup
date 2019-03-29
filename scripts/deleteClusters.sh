#!/bin/bash

 print_help(){
cat << EOF
Usage: $0 [OPTIONS]...

Delete Clusters.

Mandatory arguments to long options are mandatory for short options too.
  -r=,  --cluster-range=NUM1-NUM2    range from NUM1 to NUM2 for cluster numbers;
  -h   --help                        display this help and exit

EOF
}

for OPT in "$@"; do
    case "$OPT" in
        -r=*|--cluster-range=*)
            CLUSTER_RANGE="${OPT#*=}"
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

CSTART=$(cut -d '-' -f1 <<< "$CLUSTER_RANGE");
CEND=$(cut -d '-' -f2 <<< "$CLUSTER_RANGE");

for num in $(seq -f "%03g" "$CSTART" "$CEND"); do
    CLUSTER_NAME="user$num-cluster"
    echo "Deleteing cluster $CLUSTER_NAME ..."
    ibmcloud ks cluster-rm --cluster "$CLUSTER_NAME" -f --force-delete-storage
done
