#!/bin/bash

for OPT in "$@"; do
    case "$OPT" in
        -r=*|--cluster-range=*)
            CLUSTER_RANGE="${OPT#*=}"
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

CSTART=$(cut -d '-' -f1 <<< "$CLUSTER_RANGE");
CEND=$(cut -d '-' -f2 <<< "$CLUSTER_RANGE");

for num in $(seq -f "%03g" "$CSTART" "$CEND"); do
    CLUSTER_NAME="user$num-cluster"
    echo "Deleteing cluster $CLUSTER_NAME ..."
    ibmcloud ks cluster-rm --cluster "$CLUSTER_NAME" -f --force-delete-storage
done
