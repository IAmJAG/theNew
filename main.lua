scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "?.lua"


require 'initialize'
require 'dictionary'
require 'pattern'	
require 'task'
require 'gamemode'
require 'region'
require 'profile'

local dlgSelectScript = function()
	local sp = scrptPth ..  "data/"
	local jsonList = GU:scanDirectory(sp, "json")
	
	dialogInit()
	addTextView("")
	newRow()
	addRadioGroup("scriptNum", 1)
	for i, f in ipairs(jsonList) do
        local shortName = f:gsub(sp .. "/", "")
        addRadioButton(shortName, i)
        jsonList[i] = shortName
    end
	addRadioButton("Create new script", #jsonList+1)
	newRow()
	
	addTextView("")
	newRow()
	addTextView("     ")
	addCheckBox("learn", "Learn", false)
	addTextView("         ")
	addCheckBox("useMI", "Use mini images", true)

	dialogShow('Select Script ')
	
	local doLearn 	= learn
	local useMini 	= useMI
	local scrpt		= scriptNum
	
	--clean up
	learn 		= nil
	useMI 		= nil
	scriptNum 	= nil
	
	return doLearn, useMini, jsonList[scrpt]
end

status("Select script to run")
local doLearn, useMini, scrptName = dlgSelectScript()



setImagePath(scrptPth .. 'images')

local mod = gamemode()
status('Read json file')

mod:readJSON(scrptPth .. 'data/' .. scrptName)
 
--mod:setImagePath()	

status(getImagePath())
wait(2)

status('Get entry point')
local key = mod:getEntryPoint()
status('Get first task; entry point is ' .. key )

local task = mod:getTask(key)

local mff = profile()

while task ~= nil do
	status('Executing task ID ' .. task.taskID)
	task = mod:getTask(task:execute(mff))
end

mod:saveJSON(scrptPth .. 'data/mod1.json')
print('end')