--Initialize Application
local scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "?.lua"

JSON = httpGet("http://regex.info/code/JSON.lua")