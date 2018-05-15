--Initialize Application
local scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "?.lua"
package.path = package.path .. ";" .. scrptPth .. "modules/?.lua"
package.path = package.path .. ";" .. scrptPth .. "utilities/?.lua"
package.path = package.path .. ";" .. scrptPth .. "utilities/statusbar/?.lua"

require 'logger'
SCR = getAppUsableScreenSize()
_G:InitializeLogger(scrptPth .. 'logs/' .. string.format("%s.log", os.date("%Y%m%d")))

settrace(OFF)

require 'class'
require 'statusBar'
require 'textSection'
require 'gameutility'

statBar = statusbar()
local textStat = statBar:addSection(textsection)

statBar:show()

status = function(msg)
	textStat:Status(msg)
end