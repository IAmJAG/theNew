class('gamemode')

require 'dictionary'

gamemode.Name						= name or ''
gamemode.tasks					= dictionary()
gamemode.patterns				= dictionary()
gamemode.dateCompleted	= false
gamemode.timeResume 		= GU:ms()
gamemode.minimizePath		= ""
gamemode.ImagePath			= ""

function gamemode:isMinimized()
	local ret = true 
	for key, pat in pairs(self.patterns.items) do
		if not pat.minimized then
			ret = false
		end
		pat:setMinimizedPath(self.minimizePath)
	end	
	return ret
end

function gamemode:setImagePath()
	assert(self.minimizePath ~= "", "Path not specified!")
	
	if self:isMinimized() then
		setImagePath(self.minimizePath)
	else
		setImagePath(self.ImagePath)
	end
end
	
function gamemode:suspend(timeout)
	self.timeResume = timeout
end

function gamemode:IsSuspended()
	return self.timeResume <= GU:ms()
end

function gamemode:complete()
	self.dateCompleted = os.date("%Y%m%d")
end

function gamemode:IsCompleted()
	return self.dateCompleted < os.date("%Y%m%d")
end

function gamemode:canRun()
	return (not self:IsCompleted()) and (not self:IsSuspended())
end

function gamemode:initialize(name)
	self.Name = name
end

function gamemode:addTask(key, tsk, entryImage)
	self.tasks:addItem(tsk, key)	
	if entryImage ~= nil then
		local pat = pattern()
		pat.fileName = entryImage
		self.patterns:addItem(pat, key)
	end
end

function gamemode:removeTask(key)
	self.tasks:removeItem(key)
	self.patterns:removeItem(key)
end

function gamemode:getTask(key)
	return self.tasks:getItem(key)
end

function gamemode:getEntryPoint()
	local k = "<empty>"
	for key, pat in pairs(self.patterns.items) do
		if pat['type'] ~= nil then
			if pat.type == 'pattern' then
				print(getmetatable(pat)==nil)
				if pat:exists() == true then
					k = key
					break
				end
			end
		end
	end
	return k
end