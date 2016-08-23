-- file : fhem_mqtt.lua
local module = {}  
m = nil
t = nil

max = require("max31850")

gpio0 = 3
gpio2 = 4

max31850_pin = gpio0

-- Sends a simple ping to the broker
local function send_ping()
    --print('Ping...')
    m:publish(config.ENDPOINT.."temperature", t, 0, 0)
end

-- Sends my id to the broker for registration
local function register_myself()  
    m:subscribe(config.ENDPOINT .. config.ID, 0, function(conn)
        print("Successfully subscribed to data endpoint")
    end)
end

local function mqtt_start()

    m = mqtt.Client(config.ID, 120, "", "")
    
    -- register message callback beforehand
    m:on("message", function(conn, topic, data) 
      if data ~= nil then
        print(topic .. ": " .. data)
        -- do something, we have received a message
      end
    end)
    
    m:on("offline", function(con) print ("offline") end)
    
    m:on("connect", function(con) print ("connected") end)
    
    -- Connect to broker
    m:connect(config.HOST, config.PORT, 0, 1, function(con)
        register_myself()
        -- And then pings each 1000 milliseconds
        -- tmr.stop(6)
        -- publish a message with data = hello, QoS = 0, retain = 0
        tmr.alarm(6, 1000, 1, send_ping)
        end
    )
end


local function max_start()
    max.setup(gpio0)
    addrs = max.addrs()
    if (addrs ~= nil) then
      print("Total MAX31850 sensors: "..table.getn(addrs))
    end

    local function update_t()
        t = max.read()
        if(t==nil) then
           t=0
        end
    end
    update_t()
    -- update temperature every second
    tmr.alarm(0, 2000, 1, update_t )
end

function module.start()
    max_start()
    mqtt_start()
end


return module
