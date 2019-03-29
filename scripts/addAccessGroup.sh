#!/bin/bash

ACCESS_GROUP="${ACCESS_GROUP:-AppMod}"
USER_LIST="${USER_LIST:-email.txt}"

print_help(){
cat << EOF
Usage: $0 [OPTIONS]...

Add users from a file to an access group.

Mandatory arguments to long options are mandatory for short options too.
  -g=, --access-group=STRING       add users to STRING access group
                                       defaults to App-Mod
  -u=,  --user-list=FILE           FILE where users email addresses are stored;
                                       defaults to email.txt
  -h   --help                      display this help and exit

EOF
}

for OPT in "$@"; do
    case "$OPT" in
        -g=*|--access-group=*)
            ACCESS_GROUP="${OPT#*=}"
            ;;
        -u=*|--user-list=*)
            USER_LIST="${OPT#*=}"
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

if ! [[ -f $USER_LIST ]]; then
    echo "Required $USER_LIST not found!"
    exit 1
fi

while read -r user; do
    echo "Adding $user to $ACCESS_GROUP ..."
    ibmcloud iam access-group-user-add "$ACCESS_GROUP" "$user"
done < "$USER_LIST"
