

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

cp mongo.rep /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied MongoDB repos into yum.repos.d"

yum install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installation of MongoDB"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabled mongod"

systemctl start mongd &>> $LOGFILE

VALIDATE $? "Starting mongod"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

VALIDATE$> "Changed adress from 127.0.0.1 to 0.0.0.0" &>> $LOGFILE

systemctl restart mongod &>> $LOGFILE

VALIDATE "Restarting mongod"

