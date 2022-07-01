#!/bin/bash


##validating arguments
if [ $# -ne 1 ] 
then
	echo "Arguments missing"
	echo "it should be sh <script_name> <csv_filename>"
fi	


#bringing parameter file
. /home/saif/cohort_f11/project1/env/sqp.prm


##PASSWORD USED FOR MYSQL COMMAND
PASSWD=`sh pwd.sh`


##
cp /home/saif/cohort_f11/archive/${1} /home/saif/cohort_f11/project1/datasets/${1}


#RENAMING DATASETS
mv /home/saif/cohort_f11/project1/datasets/${1} /home/saif/cohort_f11/project1/datasets/Day.csv


##LOG FILE CREATION
LOG_DIR=/home/saif/cohort_f11/project1/logs
FILE_NAME=`basename $0`
DT=`date '+%Y%m%d_%H:%M:%S'`
LOG_FILE=$LOG_DIR/${FILE_NAME}_${DT}.log


####MYSQL COMMANDS FOR UPDATING DATE,YEAR,MONTH COLS AND TRUNCATE TABLES
mysql --local-infile=1 -uroot -p${PASSWD} < /home/saif/cohort_f11/project1/scripts/mysql_daily.txt


##validating mysql commands
if [ $? -eq 0 ]
then echo "mysql successfully executed at ${DT}" >> ${LOG_FILE}
else echo "mysql commands failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi
echo "******************************************************************************************************" >> ${LOG_FILE}


##sqoop import job execution
sqoop job --exec imp_job

##validating sqoop imprt job execution
if [ $? -eq 0 ]
then echo "sqoop import job successfully executed at ${DT}" >> ${LOG_FILE}
else echo "sqoop import job failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi
echo "******************************************************************************************************" >> ${LOG_FILE}


##hive commands
hive -f /home/saif/cohort_f11/project1/scripts/hive_daily.txt

##validating hive commands
if [ $? -eq 0 ]
then echo "hive scd successfully executed at ${DT}" >> ${LOG_FILE}
else echo "hive scd job failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi
echo "******************************************************************************************************" >> ${LOG_FILE}


#sqoop export to hdfs to rdbms
sqoop job --exec exp_job


if [ $? -eq 0 ]
then echo "sqoop exp job successfully executed at ${DT}" >> ${LOG_FILE}
else echo "sqoop exp job failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi
echo "******************************************************************************************************" >> ${LOG_FILE}


##data reconciliation
mysql --local-infile=1 -uroot -p${PASSWD} < /home/saif/cohort_f11/project1/scripts/sql_check.txt


if [ $? -eq 0 ]
then echo "sql comparison successfully executed at ${DT}" >> ${LOG_FILE}
else echo "sql comparison failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi
echo "******************************************************************************************************" >> ${LOG_FILE}


##moving csv files to archival directory
mv /home/saif/cohort_f11/project1/datasets/Day*.csv /home/saif/cohort_f11/project1/archive/Day_${DT}.csv


if [ $? -eq 0 ]
then echo "successfully archived at ${DT}" >> ${LOG_FILE}
else echo "archival failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi
echo "******************************************************************************************************" >> ${LOG_FILE}

