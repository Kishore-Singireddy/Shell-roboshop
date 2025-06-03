#!/bin/bash

#Colours
R='\e[31m'
G='\e[32m'
Y='\e[33m'
B='\e[34m'
N='\e[0m'

USERID=$(id -u)

LOG_FOLDER="/var/log/roboshop"
mkdir -p $LOG_FOLDER
LOG_PREFIX=$(echo $0 | awk -F "." '{print $1F}')
LOG_FILE="$LOG_FOLDER/$LOG_PREFIX.log"
SCRIPT_DIR=$PWD

echo -e "Script starting executing at : $(date)" | tee -a $LOG_FILE

if [ USERID -ne 0 ]
then
    echo "You don't have root access, can not proceed further " | tee -a $LOG_FILE
    exit 1
else 
    echo "You are logged as $USERID, proceding for installation " | tee -a $LOG_FILE
fi

VALIDATE () {
    if [ $1 -ne 0 ]
    then
        echo -e " $2 - $R Failed $N"
        echo -e " $Y Please check the logs $Y $LOG_FILE $N "
        exit 1
    
    else
        echo -e " $2 - $G Successful $N "

    fi

}


#Software Installations

#Check if software is installed

dnf list installed nodejs

if [ $? -ne 0 ]
then 
    echo -e "$Y No existing installation of Nodejs is found $N" | tee -a $LOG_FILE
    echo -e "$Y Proceeding to install Nodejs $N" | tee -a $LOG_FILE
    
    dnf module disable nodejs -y &>> $LOG_FILE
    VALIDATE $? "Disabling default nodejs"

    dnf module enable nodejs:20 -y &>> $LOG_FILE
    VALIDATE $? "Enabling nodejs:20"

    dnf install nodejs -y &>> $LOG_FILE
    VALIDATE $? "Installation of nodejs:20"

else
    echo -e "$R Nodejs is already installed, hence exiting the script"
    exit 1
fi

id roboshop

if [ $? -ne 0 ]
then 
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOG_FILE
    VALIDATE $? "Creating System User - roboshop"
else
    echo -e "$Y System User - roboshop already exists $N"
fi

mkdir -p /app  &>> $LOG_FILE
VALIDATE $? "Creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip
VALIDATE $? "Downloading Applicatoin"

rm -rf /app/*
cd /app

unzip /tmp/catalogue.zip &>>$LOG_FILE
VALIDATE $? "Unziping catalogue"

npm install &>> $LOG_FILE
VALIDATE $? "Installing Dependencies"

#Setting up systemd

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service &>> $LOG_FILE
VALIDATE $? "Copied catalogue.service file"

systemctl daemon-reload &>> $LOG_FILE
VALIDATE $? "Daemon Reload"

systemctl enable catalogue &>> $LOG_FILE
VALIDATE $? "Enable Catalogue"

systemctl start catalogue &>> $LOG_FILE
VALIDATE $? "Starting Catalogue"

echo -e "$Y Proceeding to check and install mongodb client $N"

cp $SCRIPT_DIR/mongodb.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE
VALIDATE $? "Copied mongodb repos"

dnf install mongodb-mongosh -y &>> $LOG_FILE
VALIDATE $? "installed mongodb client"

#LOADING DATA - 1 check if the data is already loaded and load only if not loaded.
STATUS=$(mongosh --host mongodb.singireddy.shop --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $STATUS -lt 0 ]
then
    mongosh --host mongodb.singireddy.shop </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Loading data into MongoDB"
else
    echo -e "Data is already loaded ... $Y SKIPPING $N"
fi





