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

-- CLASSLIST = {}
-- NULL = {nil}

-- local baseIndex = function(tbl, key)
	-- local meta = getmetatable(tbl)      -- get the proxy
	-- return meta[key]                    -- finaly get the key from the base
-- end

-- -- metaRoot - the root of all table(object)
-- -- 
-- local metaRoot = {__id = 0}
-- function metaRoot:copyBase()
	-- local meta      = getmetatable(self)
	-- local bClass    = setmetatable(self, nil)
	
	-- local newBase = {__id = bClass.__id} -- set index id
	
	-- for key, itm in pairs(bClass) do
			-- local typ = type(itm)
			-- if typ ~= 'function' then
					-- if type(itm) == 'table' then
							-- newBase[key] = itm:copyBase(itm)
					-- else
							-- newBase[key] = itm
					-- end
			-- end
	-- end
	
	-- if rawget(meta, '__id') == 'methods' then
			-- print('Here!')
			-- local methods = meta
			-- meta = getmetatable(methods)                -- get metatable
			-- methods = setmetatable(methods, nil)        -- clear metatable
			-- local newMethods = {__id = 'methods'}
			-- for key, itm in pairs(methods) do
					-- local typ = type(itm)
					-- if typ == 'function' then
							-- newMethods[key] = itm
					-- end
			-- end
			
			-- newMethods.__index = newMethods
			-- newMethods.__newindex = newMethods
			-- setmetatable(methods, meta)
			-- setmetatable(newMethods, meta)
			-- meta = newMethods
	-- end
	
	-- newBase.__index = newBase
	-- newBase.__newindex = newBase
	-- setmetatable(self, meta)
	-- setmetatable(newBase, meta)
	-- return newBase
-- end

-- function metaRoot:getObjectInstance(clsid, instanceid)
-- return CLASSLIST[clsid].instances[instanceid]
-- end

-- metaRoot.__index    = baseIndex

-- metaRoot.__newindex = function(tbl, key, newValue)
	-- local base = tbl
	-- local id   = rawget(base, '__id')
	-- if id == 'base' then
			-- newValue = newValue or NULL
			-- if type(newValue) == 'function' then
					-- while base ~= nil and id ~= 'methods' do
							-- base = getmetatable(base)
							-- id = rawget(base, '__id')
					-- end
					-- assert(base~=nil, 'Method metatable is not available')
					-- rawset(base, key, newValue)
			-- else
					-- rawset(base, key, newValue)
			-- end
	-- else
			-- error('Invalid assignment ' )
	-- end
-- end

-- metaRoot.__call     = function(tbl, key)
	-- local clsid = key:lower()
	
	-- assert(CLASSLIST[clsid]==nil, 'Class already registered!')
	
	-- local newClass = tbl:copyBase()
	-- local proxy = {}
	-- setmetatable(proxy, newClass)
	
	-- CLASSLIST[clsid] = {
				-- ID = clsid
			-- , instances = {
					-- {
							-- ID          = 0
						-- , instance    = proxy
					-- }
			-- }
	-- }
	-- return proxy
-- end

-- local methods = {__id = 'methods'}
-- methods.__index = metaRoot.__index
-- methods.__newindex = metaRoot.__newindex
-- methods.__call = metaRoot.__call
-- setmetatable(methods, metaRoot)

-- class = {__id = 'base'}
-- setmetatable(class, methods)

-- local newClass = class('newClass')

-- print('Test property restriction')
-- print('New Property')

-- newClass.newProperty = function() return 0 end
-- -- base -> root -> methods
-- print(rawget(getmetatable(getmetatable(getmetatable(newClass))), '__id'))
-- print(newClass.newProperty)























