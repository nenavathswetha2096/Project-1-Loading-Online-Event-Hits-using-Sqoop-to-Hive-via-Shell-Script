create database if not exists project_1;
use project_1;
set global local_infile=1;
create table if not exists customers(
custid int,
username varchar(30),
quote_count varchar(30),
ip varchar(30),
entry_time varchar(30),
prp_1 varchar(30),
prp_2 varchar(30),
prp_3 varchar(30),
ms varchar(30),
http_type varchar(30),
purchase_category varchar(30),
total_count varchar(30),
purchase_sub_category varchar(30),
http_info varchar(30),
status_code int,
year_col int,
month_col int);


create table if not exists reconciliation(
custid int,
username varchar(30),
quote_count varchar(30),
ip varchar(30),
entry_time varchar(30),
prp_1 varchar(30),
prp_2 varchar(30),
prp_3 varchar(30),
ms varchar(30),
http_type varchar(30),
purchase_category varchar(30),
total_count varchar(30),
purchase_sub_category varchar(30),
http_info varchar(30),
status_code int,
year_col int,
month_col int
);





