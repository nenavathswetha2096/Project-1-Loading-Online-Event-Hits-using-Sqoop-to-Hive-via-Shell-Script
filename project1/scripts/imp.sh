#!bin/bash
. /home/saif/cohort_f11/project1/env/sqp.prm

sqoop import \
--connect jdbc:mysql://${HOST}:${PORT_NO}/${DB_NAME}?useSSL=False \
--username ${USERNAME} --password-file ${PASSWORD_FILE} \
--query "SELECT custid, username, quote_count, ip, entry_time, prp_1, prp_2, prp_3, ms, http_type, purchase_category, total_count, purchase_sub_category, http_info, status_code,date_col,year,month FROM customers_pro WHERE \$CONDITIONS" -m 1 \
--delete-target-dir \
--target-dir ${OP_DIR}
