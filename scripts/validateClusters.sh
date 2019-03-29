#!/bin/bash


for OPT in "$@"; do
    case "$OPT" in
	-h|--help)
            echo "Usage: "$0" -r=1-10"
            exit 2
            ;;
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

CSTART=$(cut -d'-' -f1 <<< "$CLUSTER_RANGE")
CEND=$(cut -d'-' -f2 <<< "$CLUSTER_RANGE")

for num in $(seq -f "%03g" "$CSTART" "$CEND"); do
    CLUSTER_NAME="user$num-cluster"
    echo "Validating cluster $CLUSTER_NAME ..."

    ING_DOMAIN=`ibmcloud ks cluster-get $CLUSTER_NAME | grep "Ingress Subdomain" | cut -d ':' -f2 | awk '{$1=$1};1'`
    if [ "$ING_DOMAIN" == "-" ]; then
       STATUS="   Ingress subdomain not initialized: $ING_DOMAIN"
       echo "$STATUS"
    fi
    ############################
    # Add pther validations here
    ############################

    [ -z "$STATUS" ] && echo -e "$CLUSTER_NAME looks good! \n" || echo -e "$CLUSTER_NAME failed validation :(\n"    
done
