DATE=$(date +%F)
LOGSDIR='/tmp'
# /home/centos/shell-script-logs/script-name-date.log

SCRIPT_NAME=$0

LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(whoami)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID != "root" ]; then
echo "$R ERROR:: Please run this script with root access $N"
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE

VALIDATE $? "Setting up NPM Source"

yum install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing NOdeJS"

#once the user is created,if you run this script 2nd time
# this command will definitely fail

# first check the user exists or not, if not exist then create

id roboshop &>> $LOGFILE
if [ $? -e 0 ]; then
echo "roboshop user already exists"
exit 1
fi
VALIDATE $? "Checking robshop user doesnot exist"

useradd roboshop &>> $LOGFILE

VALIDATE $? "Creating roboshop user"

if [ ! -d '/app' ]; then
mkdir /app &>> $LOGFILE
else
echo "app directory already exists"
fi

VALIDATE $? "Creating a directory named app"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "Downloading catalogue.zip"


cd /app 

VALIDATE $? "Navigating to the app directory"

unzip /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "Unziping the catlogue.zip"

npm install &>> $LOGFILE

VALIDATE $? "Installing npm"

# give full path of catalogue.service because we are isnide /app

cp /home/centos/Roboshop/catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? "Copying catalogue.service"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "daemon-reload"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "Starting catlague"

cp /home/centos/Roboshop/mongo.repo /etc/yum.repos.d/mongo.repo 

VALIDATE $? "Copied mongo.repo"

yum install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Installing mongo client"

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js

VALIDATE $? "LOading catalogue data into mongodb"
