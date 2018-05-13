scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "?.lua"

require 'initialize'

setImagePath(scrptPth .. 'images')

local key = mod:getEntryPoint()
local task = mod:getTask(key)
while task ~= nil do
	task = mod:getTask(task:execute(profile))
end


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