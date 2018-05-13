scrptPth = scriptPath()
package.path = package.path .. ";" .. scrptPth .. "?.lua"

setImagePath(scrptPth .. 'images')

require 'initialize'
require 'pattern'	
require 'task'
require 'gamemode'
require 'dictionary'

local pat = pattern()
local tsk = task()
pat.fileName = 'enter.pat.png'
tsk:initialize('wait', pat, 500, pat.fileName)

local mod = gamemode()
mod.Name = 'sample'

mod:addTask(pat.fileName, tsk, pat.fileName)

print(mod:encode())