#!/bin/bash

ENTITLED_REGISTRY="${ENTITLED_REGISTRY:-cp.icr.io}"
ENTITLED_REGISTRY_USER="${ENTITLED_REGISTRY_KEY:-ekey}"
ICPA_VERSION="${ICPA_VERSION:-3.0.1.0}"

print_help(){
cat << EOF
Usage: $0 [OPTIONS]...

Install Cloud Pak for Applications

Create an IBM Cloud API key and export it in your shell before running this script:
export IBM_CLOUD_APIKEY=<my api key>
This is required for automating access to the oc cli

Mandatory arguments to long options are mandatory for short options too.
  -r=,  --cluster-range=NUM1-NUM2    range from NUM1 to NUM2 for cluster numbers;
                                         defaults to 1-50
  -key=,  --entitled-registry-key=<apikey>   key to use for entitled registry login
  -h   --help                        display this help and exit

EOF
}

for OPT in "$@"; do
    case "$OPT" in
        -r=*|--cluster-range=*)
            CLUSTER_RANGE="${OPT#*=}"
            ;;
        -key=*|--entitled-registry-key=*)
            ENTITLED_REGISTRY_KEY="${OPT#*=}"
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

if [[ -z $ENTITLED_REGISTRY_KEY ]]; then
    echo "Error: entitled registry key required"
    print_help
    exit 3
fi

if [[ -z $IBM_CLOUD_APIKEY ]]; then
    echo "Error: environment variable with IBM Cloud API key required"
    print_help
    exit 3
fi

# log in to registry
echo $ENTITLED_REGISTRY_KEY | docker login "$ENTITLED_REGISTRY" -u "$ENTITLED_REGISTRY_USER" --password-stdin

export ENTITLED_REGISTRY=$ENTITLED_REGISTRY
export ENTITLED_REGISTRY_USER=$ENTITLED_REGISTRY_USER
export ENTITLED_REGISTRY_KEY=$ENTITLED_REGISTRY_KEY

# create folder and extract config files
mkdir data
docker run -v $PWD/data:/data:z -u 0 \
          -e LICENSE=accept \
          "$ENTITLED_REGISTRY/cp/icpa/icpa-installer:$ICPA_VERSION" cp -r "data/*" /data

# disable installation of TA
sed -i".bak" -e 's/config: "transadv.yaml"/config: ""/' data/config.yaml && rm data/config.yaml.bak

CSTART=$(cut -d'-' -f1 <<< "$CLUSTER_RANGE");
CEND=$(cut -d'-' -f2 <<< "$CLUSTER_RANGE");

for num in $(seq -f "%02g" "$CSTART" "$CEND"); do
    # CLUSTER_NAME="user$num-cluster"
    CLUSTER_NAME="cp4a-fi-$num"
    echo "Configuring cluster $CLUSTER_NAME ..."
    
    # install Cloud Pak for Applications
    docker run -u 0 -t -v $PWD/data:/installer/data:z -e LICENSE=accept -e ENTITLED_REGISTRY \
    -e ENTITLED_REGISTRY_USER -e ENTITLED_REGISTRY_KEY  -e OPENSHIFT_USERNAME=apikey \
    -e OPENSHIFT_URL="$(ibmcloud oc cluster get "$CLUSTER_NAME" --json | jq .serverURL |  tr -d \" )" \
    -e OPENSHIFT_PASSWORD="$IBM_CLOUD_APIKEY" "$ENTITLED_REGISTRY/cp/icpa/icpa-installer:$ICPA_VERSION" install

done

# clean up config file directory (uncomment to view install logs)
rm -rf data
