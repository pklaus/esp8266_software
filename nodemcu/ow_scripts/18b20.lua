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
          print("P="..present)  
          data = nil
          data = string.char(ow.read(pin))
          for i = 1, 8 do
            data = data .. string.char(ow.read(pin))
          end
          print(data:byte(1,9))
          crc = ow.crc8(string.sub(data,1,8))
          print("CRC="..crc)
          if crc == data:byte(9) then
             t = (data:byte(1) & 0xfc + data:byte(2) * 256) * 625
             t1 = t / 10000
             print("Temperature = "..t1)
          end                   
          tmr.wdclr()
        until false
  else
    print("CRC is not valid!")
  end
end