#!/bin/bash

# Количество дней сколько будет храниться бекап базы
dstore=14
# Директория хранения дампов баз данных
backupdsql=/backup/sql
# Дата создания бекапа
currentdate=`date +%F`
# Директория хранени по дате бекапов баз данных сайтов
currentbackupdir=$backupdsql/$currentdate
mkdir -p $currentbackupdir
chmod -R 0770 $currentbackupdir
logfile=$currentbackupdir/filestat.log
# параметры подключения к MySQL должны быть прописаны в файле my.cnf
databases=`mysql -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases 
do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] ; then
        mysqldump --databases $db > $currentbackupdir/$db.sql
    fi
done

# Удаление директорий с дампами баз данных старше значения $dstore
find $backupdsql -type d -mtime +$dstore -delete
