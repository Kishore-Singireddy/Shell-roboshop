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
        echo -e " $Y Please check the logs $Y $LOG_FILE $N "
    
    else
        echo -e " $2 - $R Successful $N "

    fi

}

cp mongodb.repo /etc/yum.repos.d/mongo.repo  &>> $LOG_FILE
VALIDATE $? "mongodb repo creation"



dnf list installed mongodb &>> $LOG_FILE

if [ $? -ne 0 ]
then 
    echo -e " Mongodb is not installed - $Y Proceeding to install it $N" tee -a $LOG_FILE
    dnf install mongodb-org -y  &>> $LOG_FILE
    VALIDATE $? "mongodb Installation"

else 
    echo -e " $G MongoDB is already Installed - No Action required $N " tee -a $LOG_FILE

fi

systemctl enable mongod &>> $LOG_FILE
VALIDATE $? "Enabling mongod"

systemctl start mongod &>> $LOG_FILE
VALIDATE $? "Starting mongod"

sed -i 's/127.0.0.0/0.0.0.0/g' </etc/mongod.conf &>> $LOG_FILE
VALIDATE $? "Updating IP in mongod.conf"

systemctl start mongod &>> $LOG_FILE
VALIDATE 4? "Starting mongod" 


