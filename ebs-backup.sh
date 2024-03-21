#!/bin/bash

VOL=($(aws ec2 describe-volumes --filter Name=tag:Billing,Values=MyProject --query "Volumes[*].VolumeId" --output text --region us-east-2))

###################### List Volumes attached to EC2 Instances of NodeGroup for EKS Cluster ######################
echo "Volumes with the volume ID listed below:"
for i in ${VOL[*]}
do
        echo $i
done

echo -e "\n"
###################### Create Snapshot of the Attached Volumes ##################################################
echo "Snapshots of the listed Volumes:"
for i in ${VOL[*]}
do
        aws ec2 create-snapshot --volume-id $i --query 'SnapshotId' --output text --region us-east-2
done

echo -e "\n"

######## This shell script creates backup of EC2 Instances of NodesGroup of EKS Cluster through snapshot ########
##### Please wait for some time to get the snapshot status to come into Completed state from Pending state ######
