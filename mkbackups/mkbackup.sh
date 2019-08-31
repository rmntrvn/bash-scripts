#!/bin/bash

# количество дней которые будут хранится копии
daystostore=21
# директория хранения бекапов
backupdir=/backup/sites
# Массив директорий, которые необходимо бекапить
declare -a dirs=(
"/var/www/site.ru"
"/var/www/subdomain1.site.ru"
"/var/www/subdomain2.site.ru"
)
# Формат даты Y_M_D
currentdate=`date +%F`
currentbackupdir=$backupdir/$currentdate
mkdir -p $currentbackupdir
chmod -R 0770 $currentbackupdir
logfile=$currentbackupdir/filestat.log

echo `date` > $logfile
for i in "${dirs[@]}"
do
    filename=$currentbackupdir/${i##*/}.tar.gz
    tar -czf $filename --null -T $i >> $logfile
done

# Назначение прав для доступа к файлам архивов, т.к. создаются файлы пользователем с другимим правами
chmod -R 0770 $currentbackupdir
chown -R root:"admin" $currentbackupdir

# Удаление старых архивов / Директория старше значения $daystore будет удалена
find $backupdir -type d -mtime +$daystostore -delete
