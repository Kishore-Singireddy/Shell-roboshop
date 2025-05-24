#!/bin/bash
AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-06e1b399be05bca65"
ZONE_ID="Z02669663M5NZUABP37AR"
ZONE="singireddy.shop"
INSTANCES=("mongodb" "redis" "mysql" "rabitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")

for instances in ${INSTANCES[@]}

do
$INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $SG_ID "ResourceType=instance,Tags=[{Key=Name, Value=$instance}]" --query "Instances[0].InstanceId" --output text)

echo "$INSTANCE_ID"

    # if [ $instance != "frontend" ]
    # then
    #     IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)

    # echo " This is instances - $instances "
    # echo " This is INSTANCES - ${INSTANCES[@]} "
done

