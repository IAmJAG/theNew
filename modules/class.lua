--======== CLASS ==========--

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
	end
	
	rawset(base, '_data', self)	
	return cls 
end

local decode = function(self, strJSON)	
	local _data = self.json:decode(strJSON)	
	assert(_data.type == self.typeOf(), 'Invalid type!')
	_data.type = nil
	
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

local baseIndex =  function(tbl, key)
-- get base table
	local base = getmetatable(tbl)
	trace('Triggered __index from ' .. rawget(base, '_id'))
	
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
	local base = getmetatable(tbl)
	trace('Triggered __newindex from ' .. rawget(base, '_id'))
	
	assert(tbl[key]~=nil, key .. ' Member not found!')
	
	if type(newValue) == 'function' then
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
	trace('Triggered __newindex from ' .. rawget(base, '_id'))
end

clone = function(self)
	local newClone = {}
	for key, itm in pairs(self) do
		if typeOf(itm) == 'table' then
			itm.clone = clone
			newClone[key] = itm:clone()
			itm.clone = nil
			newClone[key].clone = nil
		else
			newClone[key] = itm
		end
	end	
	return newClone
end

local classCall = function(tbl)
	local clsBase 	= getmetatable(tbl)
	local clsid 		= clsBase._id
	local data      = rawget(clsBase, '_data')
	local methods   = rawget(clsBase, '_methods')
	
	data.clone = clone
	local newData = data:clone()
	newData.clone = nil
	data.clone = nil
	
	methods.clone = clone
	local newMethods = methods:clone()
	newMethods.clone = nil
	methods.clone = nil
	
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

class = {_id = 'base', _data = {}, _methods = {}}      -- our object
class.__index = baseIndex

local classRoot = { _id = 'root', 
	__index = rootIndex,
	__newindex = rootNewIndex
}

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

setmetatable(class, classRoot)