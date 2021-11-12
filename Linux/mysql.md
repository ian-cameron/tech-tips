## MySQL Support
Use mysqldump to save a database
```
mysqldump -h 127.0.0.1 -u username -p  db_name > ~/dumps/dump_file.sql
```

copy the dump to the new server. You could pull it to the new server into a folder named dumps using SCP like this
```
scp -P <port> <user>@<remote host>:<remote path>/<dump file name>.sql dumps/
```

To restore it, first create the new database with mysqlcli if necessary then restore the dump to the new database
```
mysql -h <host> -u <username> -p
mysql> create database <new db name>;
mysql> quit;
Bye
```
next, restore the dumped database
```
mysql -h <host> -u <username> -p <new db name> < ~/dumps/<dump file name>.sql
```