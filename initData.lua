scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "?.lua"

setImagePath(scrptPth .. 'images')

require 'initialize'
require 'dictionary'
require 'pattern'	
require 'task'
require 'gamemode'


local pat = false
local tsk = false
local mod = gamemode()
mod.Name = 'Co-op Play'

mod.ImagePath = scrptPth .. 'images'
mod.minimizePath = mod.ImagePath .. "/mini"

mod:setImagePath()

pat = pattern()
tsk = task()
pat.fileName = 'co-op.pat.png'
tsk:initialize('click', pat, 500, pat.fileName)
mod:addTask(pat.fileName, tsk, pat.fileName)


pat = pattern()
tsk = task()
pat.fileName = 'enter.pat.png'
tsk:initialize('click', pat, 500, pat.fileName, nil, 'co-op.pat.png')
mod:addTask(pat.fileName, tsk, pat.fileName)

-- dict = dictionary()

-- dict:addItem(1, tsk)

local mod2 = gamemode()
mod2:decode(mod:encode())

mod:saveJSON(scrptPth .. 'data/mod1.json')
mod2:readJSON(scrptPth .. 'data/mod2.json')