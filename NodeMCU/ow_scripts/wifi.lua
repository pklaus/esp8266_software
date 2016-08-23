
-- Connect to WiFi and get IP

print("wifi")
wifi.setmode(wifi.STATION)
wifi.sta.config(config.SSID, config.PSK)
wifi.sta.connect()
--tmr.delay(1000000)   -- wait 1,000,000 us = 1 second
--while wifi.sta.getip()== nil do
--  tmr.delay(100000)
--end
print("\n====================================")
print("ESP8266 mode is: " .. tostring(wifi.getmode()))
print("Status is " .. wifi.sta.status())
print("MAC address is: " .. tostring(wifi.ap.getmac()))
print("IP is " .. tostring(wifi.sta.getip()))
print("====================================")

print("/wifi")
