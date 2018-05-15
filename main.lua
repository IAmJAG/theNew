scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "?.lua"

require 'initialize'
require 'dictionary'
require 'pattern'	
require 'task'
require 'gamemode'
require 'region'
require 'profile'

setImagePath(scrptPth .. 'images')

local mod = gamemode()
status('Read json file')
mod:readJSON(scrptPth .. 'data/mod1.json')


status(getImagePath())

status('Get entry point')
local key = mod:getEntryPoint()
status('Get first task; entry point is ' .. key )

local task = mod:getTask(key)

local mff = profile()

while task ~= nil do
	status('Executing task ID ' .. task.taskID)
	local tid  = task:execute(mff)
	task = mod:getTask(tid)
end

mod:saveJSON(scrptPth .. 'data/mod1.json')
print('end')


-- local tsk1 = otk.create('wait')
-- -- local pat = opa.create('co-opplay.pat.png')
-- -- tsk1.pslr = opa.create('waitCoop')
-- tsk1.timeOut = 2000

-- -- -- local tsk2= otk.create('click')
-- -- -- pat = opa.create('co-opplay.pat.png')
-- -- -- tsk2.pslr = oGU:patternToLocation(pat)

-- mod:addTask('waitCoop', tsk1)
-- -- mod:addTask('co-opplay.pat.png', tsk2, 'co-opplay.pat.png')

-- oGU:saveJSON(mod, oGU.scriptPath .. 'data/storyMode.json')
-- -- scriptExit()