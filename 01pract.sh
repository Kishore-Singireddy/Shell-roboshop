#!/bin/bash
AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-06e1b399be05bca65"
ZONE_ID="Z02669663M5NZUABP37AR"
ZONE="singireddy.shop"
INSTANCES=("mongodb" "redis" "mysql" "rabitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")

for instances in ${INSTANCES[@]}

do

INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=$instances}]" --query "Instances[0].InstanceId" --output text)

#echo "$instances = $INSTANCE_ID"

    if [ $instances != "frontend" ]
    then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
    fi

    echo " This is the $instances ip address $IP "
done

