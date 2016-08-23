
from umqtt.simple import MQTTClient

C = MQTTClient("micropython", "udoo")
C.connect()

def publish(topic, msg):
    C.publish(topic, msg)

def disconnect():
    C.disconnect()
