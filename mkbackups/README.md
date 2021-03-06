# Bash-скрипты создания резервных копий директорий и дампов баз данных

Задание:

1. Необходимо в директорию `/backup/sites/{Y_m_d}/` размещать архивы вида соответствующего названию сайта на сервере.
```
site.ru.tar.gzip
sub1.site.ru.tar.gzip
sub2.site.ru.tar.gzip
```
и т.д.
Хранить директории 3 недели, более старые удаляются автоматически.

2. Каждый день складывать SQL дампы баз данных и хранить их 14 дней в директории `/backup/sql/{Y_m_d}/`

---

1. Скрипт [mkbackup.sh](mkbackup.sh) 
- Массив `dirs` содержит директории из которых будут созданы архивы резерных копий.
- `daystostore` - количество дней, сколько будут храниться резервные копии директорий сайтов.
- `backupdir` - директория, в которой будут созданы директории в формате `Y_m_d` с архивами сайтов.

Если значение созданной директории `/backup/sites/{Y_m_d}/` больше, чем `daystore`, то директория удаляется.

2. Скрипт [mksqldumps.sh](mksqldumps.sh)
- Переменаня `backupdsql` содержит директорию, в которой будут созданы директории в формате `Y_m_d`, в которых будут располагаться дампы баз данных.
- `dstore` - количество дней, сколько будут храниться резервные копии директорий с дампами баз данных.

Если значение созданной директории `/backup/sql/{Y_m_d}/` больше, чем `dstore`, то директория удаляется.
