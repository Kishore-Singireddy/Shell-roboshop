#!/bin/bash

#Colours
R='\e[31m'
G='\e[32m'
Y='\e[33m'
B='\e[34m'
N='\e[0m'

USERID=$(id -u)

if [ USERID -ne 0 ]
then
    echo "You don't have root access, can not proceed further "
    exit 1
else 
    echo "You are logged as $USERID, proceding for installation"
fi


LOG_FOLDER="/var/log/roboshop"
mkdir -p $LOG_FOLDER
LOG_PREFIX=$(echo $0 | awk -F "." '{print $1F}')
LOG_FILE="$LOG_FOLDER/$LOG_PREFIX.log"

VALIDATE () {
    if [ $1 -ne 0 ]
    then
        echo -e " $2 - $R Failed $N"
        echo -e " $Y Exiting the installation, Please check the logs at $Y $LOG_FILE $N "
        exit 1
    
    else
        echo -e " $2 - $G Successful $N "

    fi

}

#Redis Specific Steps:

dnf list installed redis &>> $LOG_FILE

if [ $? -ne 0 ]
then
    dnf module disable redis -y &>> $LOG_FILE
    VALIDATE $? "Disabling Redis"

    dnf module enable redis:7 -y &>> $LOG_FILE
    VALIDATE $? "Enabling Redis" 


else 
    echo " $Y Redis is already installed, proceeding to uninstall it $N" $LOG_FILE
    dnf remove redis &>> $LOG_FILE
    VALIDATE $? "Uninstalling Redis"
        
    dnf module disable redis -y &>> $LOG_FILE
    VALIDATE $? "Disabling Redis"

    dnf module enable redis:7 -y &>> $LOG_FILE
    VALIDATE $? "Enabling redis:7" 
fi

dnf install redis -y &>> $LOG_FILE
VALIDATE $? "Installing Redis" 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf

sed -i 's/yes/no/' /etc/redis/redis.conf