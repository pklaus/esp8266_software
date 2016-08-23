#!/usr/bin/env python

import paho.mqtt.client as mqtt

HOST = '192.168.178.47'

TOPICS = [
  'test/+',
  'test/temperature',
  'test/ping',
]

def on_connect(client, userdata, rc):
    print("Connected with result code "+str(rc))
    for topic in TOPICS:
        client.subscribe(topic)

def on_message(client, userdata, msg):
    print(msg.topic + " " + str(msg.payload))

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect(HOST, 1883, 60)

client.loop_forever()
