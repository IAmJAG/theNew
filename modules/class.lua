--======== CLASS ==========--


local encode = function(self)	
	local base = getmetatable(self)
	local _data = rawget(base, '_data')
	_data.type = self:typeOf()
	return self.json:encode(_data)
end

local saveJSON = function(self, filePath)
	local strJSON = self:encode()
	local fp = io.open(filePath, "w")
	fp:write(strJSON)
	fp:close()
end

indent = function(spaces)
	local spcs = ""
	for i = 1, spaces ,1 do 
		spcs = spcs .. " "
	end
	return spcs
end

toJAGClass = function(self, pKey, indx)
	local obj = self or nil
	local indts = indent(indx * 4)
	
	if type(obj) == 'table' then
		--print(indts .. pKey .. ": ")
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
		
--		print("	Type: " .. type(obj) .. " 	key: " .. pKey)
--		print(indts .. pKey .. ": " .. tostring(obj))
	end
	
	return obj
end

local decode = function(self, strJSON)	
	local _data = self.json:decode(strJSON)	
	assert(_data.type == self.typeOf(), 'Invalid type!')
	
	for key, itm in pairs(_data) do
		_data[key] = toJAGClass(itm, key, 0)
	end
	
	local base = getmetatable(self)
	rawset(base, '_data', _data)
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
		, saveJSON = saveJSON
		, readJSON = readJSON
	}
			
	local proxy = {
		_id = 'proxy'
	}
	
	setmetatable(base, root)
	
	_G[clsid] = setmetatable(proxy, base)
end

setmetatable(class, classRoot)