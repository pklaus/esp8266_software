-- file : config.lua
local module = {}

-- WiFi
module.SSID = "Raider"
module.PSK  = "tahcheThu6naV5Phidao"

-- MQTT
module.HOST = "192.168.178.47"
module.PORT = 1883
module.ID = node.chipid()
module.ENDPOINT = "test/"

return module