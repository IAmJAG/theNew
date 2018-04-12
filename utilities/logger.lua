local intializeLogger = function (self, oFile)
	self.logger						= {}
	self.logger['version'] 			= "0.1.0"
	self.logger['level'] 				= "trace"
	self.logger['LogModes']			= {}
	self.logger['OutFile']			= oFile
	self.logger['OutToConsole']	= false
	self.logger['logString']		= ''
	self['OFF'] 								= 'OFF'
	self['ON'] 									= 'ON'
			
	local LOGMODES = {
			{CODE = 1, NAME = "trace", COLOR = "\27[34m", On = true}
		,	{CODE = 2, NAME = "debug", COLOR = "\27[36m", On = true}
		,	{CODE = 3, NAME = "info",  COLOR = "\27[32m", On = true}
		,	{CODE = 4, NAME = "warn",  COLOR = "\27[33m", On = true}
		,	{CODE = 5, NAME = "error", COLOR = "\27[31m", On = true}
		,	{CODE = 6, NAME = "fatal", COLOR = "\27[35m", On = true}
	}
	
	local levels = {}
	for i, v in ipairs(LOGMODES) do
		levels[v.NAME] = i
	end
	
	local serialize = function(o)
		local so = tostring(o)
		if typeOf(o) == "function" then
				local info = __jAGDebug.getinfo(o, "S")
				-- info.name is nil because o is not a calling level
				if info.what == "C" then
						return string.format("%q", so .. ", C function")
				else
						-- the information is defined through lines
						return string.format("%q", so .. ", defined in (" ..
										info.linedefined .. "-" .. info.lastlinedefined ..
										")" .. info.source)
				end
		elseif typeOf(o) == "table" then
			for x, a in ipairs(o) do
				so = so .. ' '  .. serialize(a)
			end
			return so
		elseif typeOf(o) == "number" or typeOf(o) == "boolean" then
				return so
		else
				return string.format("%q", so)
		end
	end
	
	__jAGError = error
	__jAGDebug = debug
			
	for i, x in ipairs(LOGMODES) do
		local nameupper = x.NAME:upper()
		self.logger.LogModes[nameupper] = 'ON'		
		self[x.NAME] = function(...)
			-- Return if logger is off
			if logger.LogModes[nameupper] == 'OFF' then return end
			-- Return if we're below the log level
			if i < levels[logger.level] then return end	
			
			local msg = serialize(...)
			
			-- for _, m in ipairs(...) do
				-- msg = msg .. ' ' .. tostring(m)
			-- end
			local info = __jAGDebug.getinfo(2, "Sl")
			local lineinfo = string.gsub(info.source, scriptPath(), "") .. ":" .. info.currentline							
			logger:__write(msg, nameupper, lineinfo)
		end
		
		self['set'.. x.NAME] = function(status)
			logger.LogModes[nameupper] = status
		end
	end	
	
	self.logger.__write = function(self, wmsg, nUpper, lnInfo)		
		if self.OutFile then
			self.logString = self.logString .. string.format("[%-6s %s] %s\n", nUpper, os.date("%X"), wmsg)
		end		

		if self.OutToConsole then
			--print(string.format("[%-6s]: %s\n", nUpper, wmsg))
		end
		
		self:push()
	end
			
	self.logger.push = function(self)
		if self.OutFile then
			local fp = io.open(self.OutFile, "a+")
			fp:write(self.logString)
			fp:close()
			self.logString = "";
		end	
	end
			
	self.push = function(self)
		self.logger:push()
	end
						
	local fp = io.open(self.logger.OutFile, "w")
	fp:write('')
	fp:close()
end

_G.InitializeLogger = intializeLogger