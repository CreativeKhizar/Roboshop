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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE

VALIDATE $? "Installing rpm releases "

yum module enable redis:remi-6.2 -y &>> $LOGFILE

VALIDATE $? "Installing rpm "

yum module enable redis:remi-6.2 -y &>> $LOGFILE

VALIDATE $? "enable redis" 

yum install redis -y &>> $LOGFILE

VALIDATE $? "Imstalling Redis "

sed -i 's/127.0.0.1/0.0.0.0' /etc/redis.conf &>> $LOGFILE

VALIDATE $? "CHANGED IPaddress"

systemctl enable redis &>> $LOGFILE

VALIDATE $? "Enable Redis"

systemctl start redis &>> $LOGFILE

VALIDATE $? "Start Redis"
