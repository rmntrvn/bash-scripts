#!/bin/bash

### START / DECLARATE VARIABLES ###

IP = 178.21.15.152
login = root
password = aevaiNgae2mi

users = (cat data | awk '{print $1}' | cut -f1 -d"@")
domains = (cat data | awk '{print $1}' | sed 's|.*@||' | sed 's/.$//')

aliases 

### END / DECLARATE VARIABLES ###