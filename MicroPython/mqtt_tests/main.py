
def connect_wifi():
    import shark
    shark.connect()


def main():
    connect_wifi()
    import mosquitto, time
    while True:
        mosquitto.publish(b'test', b'me')
        time.sleep(0.5)

if __name__ == "__main__": main()
