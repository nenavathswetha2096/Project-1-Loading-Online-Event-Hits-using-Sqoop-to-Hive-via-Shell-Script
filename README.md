# Project-1-Loading-Online-Event-Hits-using-Sqoop-to-Hive-via-Shell-Script
Sqoop, Hive, Hadoop
# Description
In this project Data is sent by the client everyday in CSV format. So load all the data in MySQL everyday and then export it to HDFS. From there load the Data to hive and do the partioning on Year and Month and implement SCD Type-1 Logic and then load the data for Data reconcilation so that no loss of data takes place at any day.
# Implementation
The project is to get the file and load the data to RDBMS initially and update the table whenever the changes happend in the data. Steps for Implementing:

Getting the source files and dump in the Edge Node.
Load the data from MySQL to HDFS.
Import the data to hive managed table from HDFS.
Partition and import the data from the managed table to External table and implement the scd logic from the day 2.
Create an intermediate table to perform data reconciliation.
Export the filtered data again to the MySQL table.
