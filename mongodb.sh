
#!/bin/bash
LOGSDIR=/tmp
SCRIPT_NAME=$0
DATE=$(date +%F)
LOGFILE=$LOGSDIR/$0-DATE.LOG
USERID=$(id -u)
if [ $USERID -ne 0 ]
then
   echo "Please run the script with root user..."
   exit 1
fi

VALIDATE() 
{
    if [ $1 -ne 0 ];
    then 
       echo "$2 is FAILURE...."
    else
       echo "$2 is SUCCESS..."
    fi
}
cp mongodb.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongodb repo"

yum install mongodb-org -y &>> $LOGGILE
VALIDATE $?  "Installing mongodb-org"

systemctl enable mongod
VALIDATE $?  "Enable mongod"

systemctl start mongod
VALIDATE $?  "starting mongod"

sed -i 's/127.0.0.1/ 0.0.0.0/' /etc/mongod.conf
VALIDATE $?  "Edited  mongod IP conf value to 0.0.0.0"

systemctl restart mongod
VALIDATE $?  "Restarting mongod"

