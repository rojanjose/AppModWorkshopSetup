#!/bin/bash

USER_LIST="${USER_LIST:-email.txt}"

for OPT in "$@"; do
    case "$OPT" in
        -u=*|--user-list=*)
            USER_LIST="${OPT#*=}"
            ;;
        *)
            echo "Unexpected flag $OPT"
            exit 2
            ;;
    esac
done

while read -r user; do
    echo "Inviting user $user ..."
    ibmcloud account user-invite "$user"
done < "$USER_LIST"
