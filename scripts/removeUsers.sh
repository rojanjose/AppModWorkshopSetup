#!/bin/bash

USER_LIST="${USER_LIST:-email.txt}"

print_help(){
cat << EOF
Usage: $0 [OPTIONS]...

Remove users from account

Mandatory arguments to long options are mandatory for short options too.
  -u=,  --user-list=FILE      FILE where users email addresses are stored;
                                  defaults to email.txt
  -h   --help                 display this help and exit

EOF
}

for OPT in "$@"; do
    case "$OPT" in
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

while read -r user; do
    echo "Removing user $user ..."
    ibmcloud account user-remove "$user" -f
done < "$USER_LIST"
