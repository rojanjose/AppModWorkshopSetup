#!/bin/bash

ACCESS_GROUP="${ACCESS_GROUP:-AppMod}"
USER_LIST="${USER_LIST:-email.txt}"


for OPT in "$@"; do
    case "$OPT" in
        -g=*|--access-group=*)
            ACCESS_GROUP="${OPT#*=}"
            ;;
        -u=*|--user-list=*)
            USER_LIST="${OPT#*=}"
            ;;
        *)
            echo "Unexpected flag $OPT"
            exit 2
            ;;
    esac
done

if ! [[ -f $USER_LIST ]]; then
    echo "Required $USER_LIST not found!"
    exit 1
fi

while read -r user; do
    echo "Adding $user to $ACCESS_GROUP ..."
    ibmcloud iam access-group-user-add "$ACCESS_GROUP" "$user"
done < "$USER_LIST"
