--======== CLASS ==========--

local encode = function(self)	
	local base = getmetatable(self)
	local _data = rawget(base, '_data')
	_data.type = self:typeOf()
	return self.json:encode(_data)
end

local decode = function(self, strJSON)	
	local _data = self.json:decode(strJSON)	
	assert(_data.type == self:typeOf(), 'Invalid type!')
	
	for key, itm in pairs(_data) do
		_data[key] = toJAGClass(itm, key, 0)
	end
	
	local base = getmetatable(self)
	rawset(base, '_data', _data)
end


local saveJSON = function(self, filePath)
	local strJSON = self:encode()
	local fp = io.open(filePath, "w")
	fp:write(strJSON)
	fp:close()
end

local readJSON = function(self, filePath)
	local strJSON = readFile(filePath)
	local obj = self:decode(strJSON)
	return obj
end

function fileExist(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function readFile(file)
  if not fileExist(file) then return '' end
  lines = ''
  for line in io.lines(file) do 
    lines = lines .. line .. '\n' 
  end
  return lines
end

local baseIndex =  function(tbl, key)
-- get base table
	local base = getmetatable(tbl)
	
-- get property table from the base
	local props = rawget(base, '_data')	
	local ret = props[key]
	
-- if key is not found in props, may be it is a function
	if ret == nil then
	-- get method table from the base
		local meths = rawget(base, '_methods')
		ret = meths[key]        
	end

-- if key is not found in props and meths, may be it is a readonly member from the metatable
	if ret == nil then
		ret = base[key]
	end	
	
	return ret
end

local baseNewIndex = function(tbl, key, newValue)
	local base = getmetatable(tbl)
	
	if __typeOf(newValue) == 'function' then
		local meths = rawget(base, '_methods')
		meths[key] = newValue
	else
		local props = rawget(base, '_data')
		props[key] = newValue
	end
end

local classNewIndex = function(tbl, key, newValue)
	assert(tbl[key]~=nil, key .. ' Member not found!')
	
	local base = getmetatable(tbl)	
	if __typeOf(newValue) == 'function' then
		local meths = rawget(base, '_methods')
		meths[key] = newValue
	else
		local props = rawget(base, '_data')
		props[key] = newValue
	end
end

local rootIndex = function (tbl, key)
	trace('Triggered _index from ' .. rawget(tbl, '_id'))
	local meta = getmetatable(tbl)
	return rawget(meta, key)
end

local rootNewIndex = function(tbl, key, newValue)
	trace('Triggered __newindex from ' .. rawget(tbl, '_id'))
	trace('This should not be triggered!')
end

local classCall = function(tbl)
	local clsBase 	= getmetatable(tbl)
	local clsid 		= clsBase._id
	local data      = rawget(clsBase, '_data')
	local methods   = rawget(clsBase, '_methods')
	
	data.copy = copy
	local newData = data:copy()
	newData.copy = nil
	data.copy = nil
	
	methods.copy = copy
	local newMethods = methods:copy()
	newMethods.copy = nil
	methods.copy = nil
	
	local base = {    
		  _id 				= clsid
		, _instanceid = 0
		, _data 			= newData
		, _methods 		= newMethods
		, __index 		= baseIndex
		, __newindex 	= classNewIndex
	}
	
	local proxy = {_id = 'proxy'}	
	setmetatable(base, getmetatable(clsBase))	
	return setmetatable(proxy, base)
end

local classRoot = { 
		_id = 'root'
	, __index = rootIndex
	, __newindex = rootNewIndex
	, __call = function(tbl, key)	
		assert(key~=nil, 'Class ID is required!')
		assert(key~='', 'Class ID is required!')
		
		local clsid = key:lower()
		local base = {
				_id 				= clsid
			, _data 			= {}
			, _methods 		= {}
			, __index 		= baseIndex
			, __newindex 	= baseNewIndex
			, __call 			= classCall
		}
			
		local root = { 				
				__index 	= rootIndex
			,	_id 			= 'root'
			, type 			= clsid
			, json 			= require('json')
			, typeOf 		= typeOf
			, encode 		= encode
			, decode 		= decode
			, saveJSON 	= saveJSON
			, readJSON 	= readJSON
		}		
	
		local proxy = {
			_id = 'proxy'
		}
			
		setmetatable(base, root)
			
		_G[clsid] = setmetatable(proxy, base)
	end
}

class = {
		__index = baseIndex
	, _id = 'base'
	, _data = {}
	, _methods = {}
}

setmetatable(class, classRoot)