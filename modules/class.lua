--======== CLASS ==========--
if trace == nil then
	trace = function(...) print(...) end
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
	trace('Triggered __newindex from ' .. rawget(base, '_id'))

	if type(newValue) == 'function' then
		local meths = rawget(base, '_methods')
		meths[key] = newValue
	else
		local props = rawget(base, '_data')
		props[key] = newValue
	end
end

local classNewIndex = function(tbl, key, newValue)
	local base = getmetatable(tbl)
	trace('Triggered _newindex from ' .. rawget(base, '_id'))
	
	assert(tbl[key]~=nil, 'Member not found!')
	
	if type(newValue) == 'function' then
		local meths = rawget(base, '_methods')
		meths[key] = newValue
	else
		local props = rawget(base, '_data')
		props[key] = newValue
	end
end

local rootIndex = function (tbl, key)
	trace('Triggered _index from ' .. rawget(base, '_id'))
	local meta = getmetatable(tbl)
	return rawget(meta, key)
end

local rootNewIndex = function(tbl, key, newValue)
	trace('Triggered __newindex from ' .. rawget(base, '_id'))
end

local clone = function(self)
	local newClone = {}
	for key, itm in pairs(self) do
		if type(itm) == 'table' then
			item.clone = clone
			newClone[key] = itm:clone()
			item.clone = nil
			newClone[key].clone = nil
		else
			newClone[key] = itm
		end
	end	
	return newClone
end

local classCall = function(tbl)
	local clsBase 	= getmetatable(tbl)
	local clsid 		= tbl._id
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
		, __index = rootIndex
	}
			
	local proxy = {
		_id = 'proxy'
	}
	
	setmetatable(base, root)
	
	return setmetatable(proxy, base)
end

setmetatable(class, classRoot)