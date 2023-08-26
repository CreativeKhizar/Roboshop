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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied MongoDB repos into yum.repos.d"

yum install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installation of MongoDB"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabled mongod"

systemctl start mongd &>> $LOGFILE

VALIDATE $? "Starting mongod"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Changed adress from 127.0.0.1 to 0.0.0.0" &>> $LOGFILE

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restarting mongod"

