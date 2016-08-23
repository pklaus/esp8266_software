#!/bin/bash

source ~/.pyvenv/playground-3.5/bin/activate

PATH=~/Programmierung/webrepl/:$PATH
#HOST=micropython
#HOST=ESP_D271F5
#HOST=192.168.4.1
HOST=nodemcu_01

webrepl_cli.py shark.py     $HOST:/shark.py
webrepl_cli.py mosquitto.py $HOST:/mosquitto.py
webrepl_cli.py main.py      $HOST:/main.py

