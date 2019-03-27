#!/bin/bash
#Script to delete clusters in a batch

for user in `cat email.txt`; 
do 

echo "Inviting user $user ..."
ibmcloud account user-invite $user; 

done


