#!/bin/bash

ACCESS_GROUP="AppMod-SS"

while read -r user; do
    echo "Adding $user to $ACCESS_GROUP ..."
    ibmcloud iam access-group-user-add "$ACCESS_GROUP" "$user"
done < email.txt
