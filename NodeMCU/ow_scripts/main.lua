

t = require("max31850")

gpio0 = 3
gpio2 = 4

t.setup(gpio0)
addrs = t.addrs()
if (addrs ~= nil) then
  print("Total MAX31850 sensors: "..table.getn(addrs))
end

-- Just read temperature
print("Temperature: "..t.read().."'C")

-- Don't forget to release it after use
t = nil
max31850 = nil
package.loaded["max31850"]=nil

