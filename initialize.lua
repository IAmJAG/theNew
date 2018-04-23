--Initialize Application
local scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "?.lua"
package.path = package.path .. ";" .. scrptPth .. "modules/?.lua"
package.path = package.path .. ";" .. scrptPth .. "utilities/?.lua"
package.path = package.path .. ";" .. scrptPth .. "utilities/statusbar/?.lua"

require 'logger'
require 'class'

print('testing print')

SCR = getAppUsableScreenSize()
_G:InitializeLogger(scrptPth .. 'logs/' .. string.format("%s.log", os.date("%Y%m%d")))

local ba = class('stat')

ba.stat = 'This is a status text'

print(ba.stat)


-- _G['statusBar'] = require('statusBar').create(0, SCR:getY()-60, SCR:getX(), 60)

-- STATUS = statusBar:addSection('textSectionBar')
-- statusBar:show()
-- function status(msg)
	-- STATUS:Status(msg)
-- end

-- status('Status bar setup done!')

wait(5)