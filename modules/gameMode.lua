class('gamemode')

require 'dictionary'

gamemode.Name						= name or ''
gamemode.tasks					= dictionary()
gamemode.patterns				= dictionary()
gamemode.dateCompleted	= false
gamemode.timeResume 		= GU:ms()
	
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
	self.tasks:addItem(key, tsk)	
	if entryImage ~= nil then
		local pat = pattern()
		pat.fileName = entryImage
		self.patterns:addItem(key, pat)
	end
end

function gamemode:removeTask(key)
	self.tasks:removeItem(key)
	self.patterns:removeItem(key)
end

function gamemode:getTask(key)
	return self.tasks[key]
end

function gamemode:getEntryPoint()
<<<<<<< HEAD
	local k = "<empty>"
	for key, pat in pairs(self.patterns.items) do
		if pat['type'] ~= nil then
			if pat.type == 'pattern' then
				print(getmetatable(pat)==nil)
				if pat:exists() == true then
=======
	local k = nil
	for key, pat in pairs(self.patterns) do
		if pat['Type'] ~= nil then
			if pat.Type == 'pattern' then
				if pat:exists() then
>>>>>>> parent of 743f754... 20180514 minimizing
					k = key
					break
				end
			end
		end
	end
	return k
end