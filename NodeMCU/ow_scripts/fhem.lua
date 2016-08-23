-- alarms
-- 0: update temperature
-- 1: send to thingspeak.com

max = require("max31850")

gpio0 = 3
gpio2 = 4

max31850_pin = gpio0

fhem_host = "192.168.178.23"
fhem_port = 8083
fhem_device = "esp8266"
thingspeak_channel = 99657
thingspeak_api_write_key = "YRVSYCBG2YPNVT8Q"

max.setup(gpio0)
addrs = max.addrs()
if (addrs ~= nil) then
  print("Total MAX31850 sensors: "..table.getn(addrs))
end

t = max.read()
print("Temperature: "..t.."'C")
if(t==nil) then
   t=0
end

-- Uebergabe der Temperatur in Fhem

function sendDataFhem()
   print ("fhem!")
   t = max.read()
   conn=net.createConnection(net.TCP, 0)
   conn:on("receive", function(conn, payload) print(payload) end )
   conn:connect(fhem_port,fhem_host)
   conn:send('GET /fhem?cmd=setreading%20'..fhem_device..'%20state%20T:%20' ..t.. '\r\n HTTP/1.1\r\nHost: www.local.lan\r\n".."Connection: keep-alive\r\nAccept: */*\r\n\r\n"')
end

-- fhem start
--tmr.alarm(3, 300000, 1, function() sendDataFhem() end )



-- Anzeige auf Website
srv = net.createServer(net.TCP)
srv:listen(80,function(conn)
   conn:on("receive",function(conn, request)
      print(request)
      local buf = ""
      buf = buf.."<h1>Heating</h1>"
      buf = buf.."<p>Temperature = "..t.."</p>\n"
      conn:send(buf)
      conn:close()
      collectgarbage()
   end)
end)


--- Get temp and send data to thingspeak.com
function sendDataThingSpeak()
    connout = nil
    connout = net.createConnection(net.TCP, 0)
 
    connout:on("receive", function(connout, payloadout)
        if (string.find(payloadout, "Status: 200 OK") ~= nil) then
            print("Posted OK");
        end
    end)
 
    connout:on("connection", function(connout, payloadout)
 
        print ("Posting...");     
 
        connout:send("GET /update?api_key="..thingspeak_api_write_key.."&field1=" .. t
        .. " HTTP/1.1\r\n"
        .. "Host: api.thingspeak.com\r\n"
        .. "Connection: close\r\n"
        .. "Accept: */*\r\n"
        .. "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"
        .. "\r\n")
    end)
 
    connout:on("disconnection", function(connout, payloadout)
        connout:close();
        collectgarbage();
    end)
 
    connout:connect(80,'api.thingspeak.com')
end


-- send data every X ms to thing speak
--tmr.alarm(0, 600000, 1, function() sendDataThingSpeak() end )
tmr.alarm(1, 6000, 1, function() sendDataThingSpeak() end )


-- update temperature every second
tmr.alarm(0, 2000, 1, function() t = max.read() end )

