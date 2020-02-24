#!/bin/bash

print_help(){
cat << EOF
Usage: $0 [OPTIONS]...

Configure Clusters.

Mandatory arguments to long options are mandatory for short options too.
  -r=,  --cluster-range=NUM1-NUM2    range from NUM1 to NUM2 for cluster numbers;
                                         defaults to 1-50
  -h   --help                        display this help and exit

  -t   --tiller                      install Tiller component of Helm v2.x, optional
EOF
}

TILLER="false";

for OPT in "$@"; do
    case "$OPT" in
        -r=*|--cluster-range=*)
            CLUSTER_RANGE="${OPT#*=}"
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        -t|--tiller)
            TILLER="true"
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

CSTART=$(cut -d'-' -f1 <<< "$CLUSTER_RANGE");
CEND=$(cut -d'-' -f2 <<< "$CLUSTER_RANGE");

for num in $(seq -f "%03g" "$CSTART" "$CEND"); do
    CLUSTER_NAME="user$num-cluster"
    echo "Configuring cluster $CLUSTER_NAME ..."

    eval $(ibmcloud ks cluster-config --cluster "$CLUSTER_NAME" --export)

    # install Tiller (Tiller component is removed since Helm v3)
    if [ $TILLER == 'true' ] 
    then    
        kubectl apply -f https://raw.githubusercontent.com/IBM-Cloud/kube-samples/master/rbac/serviceaccount-tiller.yaml
        helm init --service-account tiller
    fi

    # set up istio
    #yes | ibmcloud ks cluster-addon-enable istio-extras --cluster "$CLUSTER_NAME"
    yes | ibmcloud ks cluster addon enable istio --cluster "$CLUSTER_NAME"

    # waiting a moment for istio setup to progress
    while [[ $(kubectl get configmap istio -n istio-system 2>/dev/null | grep NAME | wc -l) -ne 1 ]]
    do
      echo "sleeping a moment for istio to configure"
      sleep 2
    done

    # patch configmap for istio to enable mixer policy checking
    kubectl get configmap istio -o yaml -n istio-system | sed 's/disablePolicyChecks: true/disablePolicyChecks: false/' | kubectl -n istio-system replace -f -
done
