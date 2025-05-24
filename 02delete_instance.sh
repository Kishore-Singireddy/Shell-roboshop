#!/bin/bash

#This script is for deleting AWS instances

#aws ec2 describe-instances

#aws ec2 terminate-instances --instance-ids i-5203422c

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-06e1b399be05bca65"
ZONE_ID="Z02669663M5NZUABP37AR"
ZONE="singireddy.shop"
INSTANCES_NM=("mongodb" "redis" "mysql" "rabitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")

#Query to list all the running ec2 instances - gives the instance ids

INSTANCES_ID=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId]' --filters Name=instance-state-name,Values=running --output text)
for instances_id in ${INSTANCES_ID[@]}
do
    aws ec2 terminate-instance --instance-id $instances_id
    INSTANCES_COUNT=${instances_id[@]}
    if [ $INSTANCES_COUNT -eq 0 ]
    then
        echo "All running instances are deleted"
    else 
        INSTANCE_NAME=$(aws ec2 describe-instances --instance-ids $instances_id --query 'Reservations[*].Instances[*].Tags' --output text)
        ONLY_INSTANCE_NAME=$(echo $INSTANCE_NAME | awk -F " " '{print $2F}')
        echo "Deleting $ONLY_INSTANCE_NAME "

    fi

   
    echo "$INSTANCES_ID - $ONLY_INSTANCE_NAME"
    delete-instance --instance-id $instances_id
done
