--Initialize Application
local scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "?.lua"
package.path = package.path .. ";" .. scrptPth .. "utilities/?.lua"
require 'logger'
JSON = assert(loadstring(httpGet("http://regex.info/code/JSON.lua")))()

