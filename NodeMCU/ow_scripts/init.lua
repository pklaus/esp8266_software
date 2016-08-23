print('init.lua')

-- d('pins')
-- https://bigdanzblog.wordpress.com/2015/04/24/esp8266-nodemcu-interrupting-init-lua-during-boot/


local function start()
    -- change to a UART baud rate of 115200
    uart.setup(0, 115200, 8, 0, 1)
    -- wait for the UART speed to be effective
    tmr.delay(500000)

    -- change from 80 (40?) MHz to 160 MHz
    node.setcpufreq(node.CPU160MHZ)
    
    config = require("config")
    fhem_mqtt = require("fhem_mqtt")
    
    -- start WiFi half a second later
    tmr.delay(500000)
    dofile('wifi.lua')
    function wait_wifi()
        if wifi.sta.getip()==nil then
            print(" Wait for IP address!")
        else
            print("WiFi now ready. IP address: "..wifi.sta.getip())
            fhem_mqtt.start()
            tmr.stop(1)
        end
    end
    tmr.alarm(1, 1000, 1,  wait_wifi)
    -- start main after 6 seconds
    --tmr.alarm(0, 6000, 0, function() dofile('main.lua') end )
    --tmr.alarm(0, 1000, 0, function() dofile('max31850_all-in-one.lua') end )
    --tmr.alarm(0, 6000, 0, function() dofile('fhem.lua') end )
    
end

tmr.alarm(0, 3000, 0, function() start() end )

print('/init.lua')
