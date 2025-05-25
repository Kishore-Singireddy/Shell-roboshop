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
echo "These are Instances IDs : ${INSTANCES_ID[@]}"

INSTANCES_COUNT=${#INSTANCES_ID[@]}
echo "This is the instance count $INSTANCES_COUNT "

if [ $INSTANCES_COUNT != 0 ]
then
    for instances_id in ${INSTANCES_ID[@]}
    do
        #aws ec2 terminate-instances --instance-id $instances_id
        REM_INSTANCES_COUNT=$($INSTANCES_COUNT -1)
        echo " These are remaining instances $REM_INSTANCES_COUNT "
        # if [ $REM_INSTANCES_COUNT == 0 ]
        # then
        #     echo "All running instances are deleted"
        # else 
        #     INSTANCE_NAME=$(aws ec2 describe-instances --instance-ids $instances_id --query 'Reservations[*].Instances[*].Tags' --output text)
        #     ONLY_INSTANCE_NAME=$(echo $INSTANCE_NAME | awk -F " " '{print $2F}')
        #     echo "Deleting $ONLY_INSTANCE_NAME "

        # fi  
    
    done
else
    echo "All running instances are deleted"
fi