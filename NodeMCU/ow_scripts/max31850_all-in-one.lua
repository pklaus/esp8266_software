-- MAX31850 NodeMCU 1-wire (ow) script
pin = 3
ow.setup(pin)
count = 0
repeat
  count = count + 1
  addr = ow.reset_search(pin)
  addr = ow.search(pin)
  tmr.wdclr()
until (addr ~= nil) or (count > 100)
if addr == nil then
  print("No more addresses.")
else
  print(addr:byte(1,8))
  crc = ow.crc8(string.sub(addr,1,7))
  if crc == addr:byte(8) then
        repeat
          ow.reset(pin)
          ow.select(pin, addr)
          ow.write(pin, 0x44, 1)
          tmr.delay(1000000)
          present = ow.reset(pin)
          ow.select(pin, addr)
          ow.write(pin,0xBE,1)
          data = nil
          data = string.char(ow.read(pin))
          for i = 1, 8 do
            data = data .. string.char(ow.read(pin))
          end
          crc = ow.crc8(string.sub(data,1,8))
          if crc == data:byte(9) then
             if bit.band(data:byte(1), 0x1) == 0 then
                t = (bit.band(data:byte(1), 0xfc) + data:byte(2) * 256) * 625
                -- integer version:
                --t1 = t / 10000
                --t2 = (t % 10000) /100
                --print("Temperature = "..t1.."."..t2)
                print("Temperature = "..(t/10000))
             else
                print("Thermocouple error. Ground loop or short in connection?")
             end
          end
          tmr.wdclr()
        until false
  else
    print("CRC is not valid!")
  end
end
