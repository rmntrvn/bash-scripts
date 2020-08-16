#!/usr/bin/env bash
# This bash script installs borgbackup and sets up a backup schedule.

set -x

LOCKFILE=/tmp/lockfile
if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
    echo "Already running"
    exit
fi

# Make sure the lockfile is removed when we exit and then claim it
trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}

# Install packages
yum install -y epel-release
yum install -y borgbackup zstd

DIR_BACKUPS='/root/backups'

# Create directories for backup repos:
mkdir -p ${DIR_BACKUPS}/{mysql-data,mysql-cfg,mysql-binlog}
mkdir -p ${DIR_BACKUPS}/{nginx-cfg,nginx-log,nginx-ssl,nginx-tmp}
mkdir -p ${DIR_BACKUPS}/{comm-data,comm-log,comm-tmp}
mkdir -p ${DIR_BACKUPS}/{jboss-data,jboss-import_tmp,jboss-launcher,jboss-liquibase-log,jboss-log,jboss-mxdata,jboss-tmp,jboss-work}
mkdir -p ${DIR_BACKUPS}/jcr-data
mkdir -p ${DIR_BACKUPS}/{wildfly-data,wildfly-data.bak,wildfly-liquibase-log,wildfly-log,wildfly-snapshots}
mkdir -p /var/log/cron-backup-logs

# Initialize the repository and create cron-jobs for backups
M=0
H=0
for repo in $(ls ${DIR_BACKUPS})
do
  borg init --encryption=none ${DIR_BACKUPS}/$repo
  if [[ $M -eq 60 ]] 
  then
    H=$((H+1))
    M=0
  else
    (crontab -l 2>/dev/null; echo "$M $H * * * /usr/bin/borg create --stats --progress --compression zstd ${DIR_BACKUPS}/$repo::"$repo-\`date +\\%Y-\\%m-\\%d\\_\\%H\\:\\%M\`" /opt/$repo >> /var/log/cron-backup-logs/"create-$repo-\`date +\\%Y-\\%m-\\%d\\_\\%H\\-\\%M\`" 2>&1") | crontab -
    M=$((M+10))
  fi
done

# Create cron jobs to delete old backups

for repo in $(ls ${DIR_BACKUPS})
do
  if [[ $M -eq 60 ]] 
  then
    H=$((H+1))
    M=0
  else
    (crontab -l 2>/dev/null; echo "$M $H 1 1-12 * /usr/bin/borg prune -v --list ${DIR_BACKUPS}/$repo --keep-within=30d --keep-weekly=4 --keep-monthly=-1 >> /var/log/cron-backup-logs/"prune-$repo-\`date +\\%Y-\\%m-\\%d\\_\\%H\\-\\%M\`" 2>&1") | crontab -
    M=$((M+10))
  fi
done

rm -f ${LOCKFILE}