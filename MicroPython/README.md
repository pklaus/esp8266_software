### Flashing MicroPython

    esptool.py --port /dev/ttyUSB0 erase_flash
    esptool.py --port /dev/ttyUSB0 --baud 115200 write_flash --flash_size=8m 0 firmware-combined.bin
    # or a release version to the NodeMCU:
    esptool.py --port /dev/ttyUSB0 --baud 460800 write_flash --flash_size=8m -fm dio 0 esp8266-20160809-v1.8.3.bin 

### Requirements

To easily upload your code, get the webrepl repository:
<https://github.com/micropython/webrepl>

### Resources

The entire documentation is to be found [here](https://docs.micropython.org/en/latest/esp8266/)
and consists mainly of the following:

* tutorial: [Tutorial](https://docs.micropython.org/en/latest/esp8266/esp8266/tutorial/intro.html)
    * Getting started with MicroPython on the ESP8266
    * Getting a MicroPython REPL prompt
    * The internal filesystem
    * Network basics
    * Network - TCP sockets
    * GPIO Pins
    * Pulse Width Modulation
    * Analog to Digital Conversion
    * Power control
    * Controlling 1-wire devices
    * Controlling NeoPixels
    * Temperature and Humidity
    * Next steps
* quickref: [Quick reference for the ESP8266](https://docs.micropython.org/en/latest/esp8266/esp8266/quickref.html) including:
    * Installing MicroPython
    * General board control
    * Networking
    * Delay and timing
    * Timers
    * Pins and GPIO
    * PWM (pulse width modulation)
    * ADC (analog to digital conversion)
    * SPI bus
    * Hardware SPI
    * I2C bus
    * Deep-sleep mode
    * OneWire driver
    * NeoPixel driver
    * APA102 driver
    * DHT driver
    * WebREPL

Some libraries are still undocumented, such as the mqtt libraries. Check the code for examples:

* <https://github.com/micropython/micropython-lib/tree/master/umqtt.simple>
* <https://github.com/micropython/micropython-lib/tree/master/umqtt.robust>
