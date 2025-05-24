#!/bin/bash
AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-06e1b399be05bca65"
ZONE_ID="Z02669663M5NZUABP37AR"
ZONE="singireddy.shop"
INSTANCES=("mongodb" "redis" "mysql" "rabitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")

for instances in {$INSTANCES[@]}
do
    echo " This is instances - $instances "
    echo " This is INSTANCES - $INSTANCES "
done

