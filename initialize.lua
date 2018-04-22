--Initialize Application
local scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "?.lua"
package.path = package.path .. ";" .. scrptPth .. "modules/?.lua"
package.path = package.path .. ";" .. scrptPth .. "utilities/?.lua"
package.path = package.path .. ";" .. scrptPth .. "utilities/statusbar/?.lua"

require 'logger'

SCR = getAppUsableScreenSize()

_G:InitializeLogger(scrptPth .. 'logs/' .. string.format("%s.log", os.date("%Y%m%d")))

_G['statusBar'] = require('statusBar').create(0, SCR:getY()-60, SCR:getX(), 60)

STATUS = statusBar:addSection('textSectionBar')
statusBar:show()
function status(msg)
	STATUS:Status(msg)
end

status('Status bar setup done!')

wait(5)