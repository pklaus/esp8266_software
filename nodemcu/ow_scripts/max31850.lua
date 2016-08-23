--------------------------------------------------------------------------------
-- MAX31850 1-wire module for NODEMCU
-- Philipp Klaus
-- LICENCE: http://opensource.org/licenses/MIT
-- Philipp Klaus (philipp.l.klaus@web.de)
-- 2016-03-15
--------------------------------------------------------------------------------

-- Set module name as parameter of require
local modname = ...
local M = {}
_G[modname] = M
--------------------------------------------------------------------------------
-- Local used variables
--------------------------------------------------------------------------------
-- MAX31850 dq pin
local pin = nil
-- MAX31850 default pin
local defaultPin = 3
--------------------------------------------------------------------------------
-- Local used modules
--------------------------------------------------------------------------------
-- Table module
local table = table
-- String module
local string = string
-- One wire module
local ow = ow
-- Timer module
local tmr = tmr
-- Limited to local environment
setfenv(1,M)
--------------------------------------------------------------------------------
-- Implementation
--------------------------------------------------------------------------------
C = 0
F = 1
K = 2
function setup(dq)
  pin = dq
  if(pin == nil) then
    pin = defaultPin
  end
  ow.setup(pin)
end

function addrs()
  setup(pin)
  tbl = {}
  ow.reset_search(pin)
  repeat
    addr = ow.search(pin)
    if(addr ~= nil) then
      table.insert(tbl, addr)
    end
    tmr.wdclr()
  until (addr == nil)
  ow.reset_search(pin)
  return tbl
end

function readNumber(addr, unit)
  result = nil
  setup(pin)
  flag = false
  if(addr == nil) then
    ow.reset_search(pin)
    count = 0
    repeat
      count = count + 1
      addr = ow.search(pin)
      tmr.wdclr()
    until((addr ~= nil) or (count > 100))
    ow.reset_search(pin)
  end
  if(addr == nil) then
    return result
  end
  crc = ow.crc8(string.sub(addr,1,7))
  if (crc == addr:byte(8)) then
    if (addr:byte(1) == 0x3b) then
      -- print("Device is a MAX31850 family device.")
      ow.reset(pin)
      ow.select(pin, addr)
      ow.write(pin, 0x44, 1)
      tmr.delay(100000)
      present = ow.reset(pin)
      ow.select(pin, addr)
      ow.write(pin,0xBE,1)
      -- print("P="..present)
      data = nil
      data = string.char(ow.read(pin))
      for i = 1, 8 do
        data = data .. string.char(ow.read(pin))
      end
      -- print(data:byte(1,9))
      crc = ow.crc8(string.sub(data,1,8))
      -- print("CRC="..crc)
      if (crc == data:byte(9)) then
        t = (data:byte(1) + data:byte(2) * 256)
        if (t > 32767) then
          t = t - 65536
        end

        t = t * 625
        --print("t = "..t/10000)

        if(unit == nil or unit == 'C') then
          -- do nothing
        elseif(unit == 'F') then
          t = t * 1.8 + 320000
        elseif(unit == 'K') then
          t = t + 2731500
        else
          return nil
        end
        t = t / 10000
        return t
      end
      tmr.wdclr()
    else
    -- print("Device family is not recognized.")
    end
  else
  -- print("CRC is not valid!")
  end
  return result
end

function read(addr, unit)
  t = readNumber(addr, unit)
  if (t == nil) then
    return nil
  else
    return t
  end
end

-- Return module table
return M

