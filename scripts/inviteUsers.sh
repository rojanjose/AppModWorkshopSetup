#!/bin/bash

while read -r user; do
    echo "Inviting user $user ..."
    ibmcloud account user-invite "$user"
done < email.txt
