--======== CLASS ==========--
<<<<<<< HEAD
copy = function(self)
	local newCopy = {}
	for key, itm in pairs(self) do
		if typeOf(itm) == 'table' then
			itm.copy = copy
			newCopy[key] = itm:copy()
			itm.copy = nil
			newCopy[key].copy = nil
		else
			newCopy[key] = itm
		end
	end	
	return newCopy
end

indent = function(spaces)
	local spcs = ""
	for i = 1, spaces ,1 do 
		spcs = spcs .. " "
	end
	return spcs
end

---------------------------- convert To jAG Class ------------------------------
toJAGClass = function(self, pKey, indx)
	local obj = self or nil
	local indts = indent(indx * 4)
	
	if type(obj) == 'table' then
		for key, itm in pairs(obj) do
			obj[key] = toJAGClass(itm, key, indx + 1)
		end
			
		if obj['type'] ~= nil then
			local cls = _G[obj.type]()
			local base = getmetatable(cls)
			rawset(base, '_data', obj)	
			--print(indts .. "xxxxxx")
			return cls			
		end
	else
		local typ = type(obj)
		
		if typ == 'nil' then
			obj = false
		end
=======

local encode = function(self)	
	local base = getmetatable(self)
	local _data = rawget(base, '_data')
	_data.type = self:typeOf()
	return self.json:encode_pretty(_data)
end

local toJAGClass = function(self)
	local cls = _G[self.type]()
	local base = getmetatable(cls)
	self.type = nil
	
	for key, itm in pairs(self) do
		print(key)
		if type(self[key]) == 'table' then
			if self[key]['type'] ~= nil then
				self[key] = toJAGClass(self[key])
			end
		end
>>>>>>> parent of 743f754... 20180514 minimizing
	end
	
	rawset(base, '_data', self)	
	return cls 
end


local encode = function(self)	
	local base = getmetatable(self)
	local _data = rawget(base, '_data')
	_data.type = self:typeOf()
	return self.json:encode(_data)
end

local decode = function(self, strJSON)	
	local _data = self.json:decode(strJSON)	
<<<<<<< HEAD
	assert(_data.type == self:typeOf(), 'Invalid type!')
=======
	assert(_data.type == self.typeOf(), 'Invalid type!')
	_data.type = nil
>>>>>>> parent of 743f754... 20180514 minimizing
	
	for key, itm in pairs(_data) do

		if type(_data[key]) == 'table' then
			if _data[key]['type'] ~= nil then
				_data[key] = toJAGClass(_data[key])
			end
		end
	end
	
	local base = getmetatable(self)
	rawset(base, '_data', _data)
end

<<<<<<< HEAD

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

=======
>>>>>>> parent of 743f754... 20180514 minimizing
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
	
	if typeOf(newValue) == 'function' then
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
	if typeOf(newValue) == 'function' then
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

<<<<<<< HEAD
class = {
		__index = baseIndex
	, _id = 'base'
	, _data = {}
	, _methods = {}
}
=======
classRoot.__call = function(tbl, key)
	assert(key~=nil, 'Class ID is required!')
	assert(key~='', 'Class ID is required!')
	
	local clsid = key:lower()
	local base = {
			_id = clsid
		, _data = {}
		, _methods = {}
		, __index = baseIndex
		, __newindex = baseNewIndex
		, __call = classCall
	}
	
	local root = { 
			_id = 'root'
		, json = require('json')
		, __index = rootIndex
		, typeOf = function(self)
			return clsid
		end
		, encode = encode
		, decode = decode
	}
			
	local proxy = {
		_id = 'proxy'
	}
	
	setmetatable(base, root)
	
	_G[clsid] = setmetatable(proxy, base)
end
>>>>>>> parent of 743f754... 20180514 minimizing

setmetatable(class, classRoot)