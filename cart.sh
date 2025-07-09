 #!/bin/bash

 USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N" | tee -a $LOG_FILE
    exit 1 #give other than 0 upto 127
else
    echo "You are running with root access" | tee -a $LOG_FILE
fi

# validate functions takes input as exit status, what command they tried to install
VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$2 is ... $G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "$2 is ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
}

dnf module disable nodejs -y
VALIDATE $? "Disable Nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "Enable Nodejs:20"

dnf install nodejs -y
VALIDATE $? "Install Nodejs"

id roboshop
if [ $? -ne 0 ]
then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
VALIDATE $? "System user create"
else
   echo -e "System user roboshop already created ... $Y SKIPPING $N"
   fi

mkdir -p /app 
VALIDATE $? "Create make directory"

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip
VALIDATE $? "Create Curl"

rm -rf /app/*
cd /app 
unzip /tmp/cart.zip
VALIDATE $? "Unzip File"

npm install 
VALIDATE $? "$Y Npm Install $N"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service
VALIDATE $? "Copying cart Service"

systemctl daemon-reload
VALIDATE $? "Daemon Reload"

systemctl enable cart 
VALIDATE $? "Enable Cart"

systemctl start cart
VALIDATE $? "Start Cart"


