
import network

STA_IF = network.WLAN(network.STA_IF)

def connect(blocking=True):
    if not isconnected():
        print('Trying to connect')
        STA_IF.active(True)
        STA_IF.connect('Shark', 'fWUb30uzee')
        while not isconnected():
            pass
    print('connected', STA_IF.ifconfig())

def isconnected():
    return STA_IF.isconnected()

def ip():
    return STA_IF.ifconfig()[0]
