# bash-скрипт для проверки доступности сервера по эхо-пакетам ICMP и проверке утилитов dig
---
1. Перед запуском скрипта необходимо создать текстовый файл со списком IP адресом в колонку и указать в указать в коде скрипта вместо `<path_to_file_list_servers>`.
2. Для запуска скрипта необходимо дать права на исполнение скрипту командой chmod +x check_list_servers_is_available.sh.
3. Запустить скрипт выполнив одну из следующих команд:
  - ./check_list_servers_is_available.sh
  - sh check_list_servers_is_available.sh
  - bash check_list_servers_is_available.sh
4. Доступные сервера будут занесены в файл `available_servers`.
