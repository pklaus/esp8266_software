#!/usr/bin/env python

import time, random

import paho.mqtt.client as mqtt

HOST = '192.168.178.47'

def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))

client = mqtt.Client()
client.on_connect = on_connect

client.connect(HOST, 1883, 60)

client.loop_start()

while True:
    time.sleep(2)
    #client.publish("test/temperature", random.random())
    client.publish("test/10439869", random.random())
