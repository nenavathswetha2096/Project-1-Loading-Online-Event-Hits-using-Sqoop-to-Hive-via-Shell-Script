#!bin/bash


##BRINGING PARAMETER FILE
. /home/saif/cohort_f11/project1/env/sqp.prm


PASSWD=`sh pwd.sh`


####LOG file CREATION
LOG_DIR=/home/saif/cohort_f11/project1/logs
FILE_NAME=`basename $0`
DT=`date '+%Y%m%d_%H:%M:%S'`
LOG_FILE=$LOG_DIR/${FILE_NAME}_${DT}.log


###mysql creating database and tables
mysql --local-infile=1 -u root -p${PASSWD} < /home/saif/cohort_f11/project1/scripts/sql_ots.txt


##validating mysql commands
if [ $? -eq 0 ]
then echo "mysql successfully executed at ${DT}" >> ${LOG_FILE}
else echo "mysql commands failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi
echo "******************************************************************************************************" >> ${LOG_FILE}



###data ingestion sqoop job creation
sqoop job --create imp_job -- import \
--connect jdbc:mysql://${HOST}:${PORT_NO}/${DB_NAME}?useSSL=False \
--username ${USERNAME} --password-file ${PASSWORD_FILE} \
--query "SELECT custid, username, quote_count, ip, entry_time, prp_1, prp_2, prp_3, ms, http_type, purchase_category, total_count, purchase_sub_category, http_info, status_code,date_col,year,month FROM customers_pro WHERE \$CONDITIONS" -m 1 \
--delete-target-dir \
--target-dir ${OP_DIR} 



####validating sqoop import job command
if [ $? -eq 0 ]
then echo "sqoop import job successfully created at ${DT}" >> ${LOG_FILE}
else echo "sqoop import job  failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi
echo "******************************************************************************************************" >> ${LOG_FILE}



###hive creating database and tables
hive -f /home/saif/cohort_f11/project1/scripts/hive_ots.txt


##validating hive queries
if [ $? -eq 0 ]
then echo "hive queries successfully created at ${DT}" >> ${LOG_FILE}
else echo "hive queries  failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi
echo "******************************************************************************************************" >> ${LOG_FILE}



##sqoop export into rdbms
sqoop job --create exp_job -- export \
--connect jdbc:mysql://${HOST}:${PORT_NO}/${DB_NAME}?useSSL=False \
--table ${SQL_RECOL_TBL} \
--username ${USERNAME} --password-file ${PASSWORD_FILE} \
--direct \
--export-dir ${EXP_DIR} --m 1 \
-- driver com.mysql.jdbc.Driver --input-fields-terminated-by ','


##sqoop export validation
if [ $? -eq 0 ]
then echo "sqoop export job successfully created at ${DT}" >> ${LOG_FILE}
else echo "sqoop export job  failed  at ${DT} " >> ${LOG_FILE}
exit 1
fi
echo "******************************************************************************************************" >> ${LOG_FILE}





