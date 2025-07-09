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
VALIDATE $? "$Y Installing Nodejs $N"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE $? "System user create"

mkdir /app 
VALIDATE $? "Make Directory"

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip 
VALIDATE $? "Installing Server"

cd /app 
unzip /tmp/user.zip
VALIDATE $? "Unzip Roboshop"

npm install
VALIDATE $? "Install npm"

cp $SCRIPT_DIR user.service /etc/systemd/system/user.service
VALIDATE $? "Copy make Directory"

systemctl daemon-reload
VALIDATE $? "Daemon Reload"

systemctl enable user 
VALIDATE $? "Enable User"

systemctl start user
VALIDATE $? "Start User"




