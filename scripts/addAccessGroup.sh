#!/bin/bash
#Script to delete clusters in a batch

ACCESS_GROUP="AppMod-SS"

for user in `cat email.txt`; 
do 

echo "Adding $user to $ACCESS_GROUP ..."
ibmcloud iam access-group-user-add $ACCESS_GROUP $user;

done


