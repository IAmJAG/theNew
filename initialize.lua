--Initialize Application
local scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "?.lua"
package.path = package.path .. ";" .. scrptPth .. "utilities/?.lua"
require 'logger'

_G:InitializeLogger(scrptPth .. 'logs/' .. string.format("%s.log", os.date("%Y%m%d")))

JSON = assert(loadstring(httpGet("http://regex.info/code/JSON.lua")))()

