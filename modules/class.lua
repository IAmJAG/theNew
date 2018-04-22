--==== Class ====---
CLASSLIST = {}
NULL = {'NULL'}
class = {classname = 'base', instanceID = 'base'}

local storageIndex = function(tbl, key)
	local meta = getmetatable(tbl)
	value = meta[key]			
	return value 
end

local classMeta = {}
classMeta.__index = function(tbl, key)
	local meta = getmetatable(tbl)
	local value = rawget(meta, key)

	assert(value~=nil, 'Property/Method ' .. key .. ' not defined!')
	
	return value 
end

function classMeta:copyBase()
	local newClass = {}
	local oldMeta	 = getmetatable(self)
	local orgClass = setmetatable(self, nil)
	
	for key, itm in pairs(orgClass) do
		local typ = typeOf(itm)
		if typ == 'table' then
			newClass[key] = orgClass[key]:copyBase()
		elseif typ == 'string' or typ == 'number' or typ == 'boolean' then
			self[key] = itm
		elseif typ == 'function' then
			print('Function are not copied')
		else
			print('Undefined type ' .. typ)
		end		
	end
	
	setmetatable(orgClass, oldMeta)
	return setmetatable(newClass, oldMeta)
end

--=============================================
-- Parameters: 
--	tbl - the caller 
--  key - new name of the class

classMeta.__call = function(tbl, key)
	assert(not(key==nil or key==''), 'Must provide class name')	
	local lKey 				= key:lower()
	
	assert(CLASSLIST[lKey] == nil, 'Class ' .. lKey .. ' already defined')
	
	local lInstanceID = 'base'
	local cClass			= #CLASSLIST + 1
	
	local newClass = tbl:copyBase()
	rawset(newClass, 'classname', lKey)
	
	newClass.__index = storageIndex
	
	newClass.__newindex = function(tbl, key, newvalue)
		local meta = getmetatable(tbl)
		local oldValue = rawget(tbl, key)
		
		if oldValue~=nil then
			assert(typeOf(newvalue)=='function', 'Invalid property assignment! Can\'t assign function to a property.')
			rawset(tbl, key, newvalue)
		else
			meta[key] = newvalue
		end
	end
	
	newClass.__call = function(tbl)
		local lClass = tbl.classname
		local lInstanceID = #CLASSLIST[lClass].instances + 1
		
		local newInstance = tbl:copyBase()		
		rawset(newInstance, 'instanceID', lInstanceID)
		newInstance.__index = storageIndex
		
		newInstance.__newindex = function(tbl, key, newvalue)		
			local meta = getmetatable(tbl)
			local oldValue = rawget(tbl, key)
			
			if oldValue~=nil then
				assert(typeOf(newvalue)=='function', 'Invalid property assignment! Can\'t assign function to a property.')
				rawset(tbl, key, newvalue)
			else
				meta[key] = newvalue
			end
		end
		
		local proxy = setmetatable({}, newInstance)
		print('aaaa' .. proxy.instanceID)		
		CLASSLIST[lKey].instances[lInstanceID] = {instanceID = lInstanceID, instance = proxy}				
		return proxy
	end
		
	setmetatable(newClass, tbl)	
	
	local proxy = setmetatable({}, newClass)
	
	rawset(proxy, 'classname', lKey)
	
	CLASSLIST[lKey] = {
			ID = cClass
		, instances = {}
	}	
	CLASSLIST[lKey].instances[lInstanceID] = {instanceID = lInstanceID, instance = proxy}
		
	return proxy
end

function classMeta:addProperty(key, value, readonly)
	assert(not(key==nil or key==''), 'Must provide property name')
	assert(self.instanceID=='base', 'Invalid operation! Can\'t add property to an instance.')
	
	value 		= value or NULL
	readonly	= readonly or false
	
	local newMeta 
	if readonly then
	else
		local lClass = self.classname
		local lInstanceID = self.instanceID
		
		newMeta = getmetatable(self)
		
		rawset(newMeta, key, value)
		local copy = CLASSLIST[lClass].instances[lInstanceID]
		setmetatable(copy, newMeta)
	end
end

class.__index = storageIndex
	
class.__newindex = function(tbl, key, newvalue)		
	local meta = getmetatable(tbl)
	local oldValue = rawget(meta, key)
	
	if oldValue==nil then
		meta = getmetatable(meta)
		oldValue = rawget(meta, key)

		if oldValue==nil then
			assert(typeOf(newvalue)~='function', 'Invalid function assignment! Please use addMethod to add a function.')
			error('Invalid property assignment! Use addProperty to add new property.')
		end
		assert(typeOf(oldValue)~='function', 'Can\'t override function ' .. key .. '.')
		error('Invalid property assignment! Property ' .. key .. ' is readonly.')
	else
		if typeOf(oldValue) == 'function' then
			assert(typeOf(newvalue)=='function', 'Invalid function assignment! Can\'t assign a value to a function.')
			error('Use overrideMethod to override a function')	
		end
		assert(typeOf(newvalue)~='function', 'Invalid property assignment! Can\'t assign a function to a property.')
		error('Invalid property assignment! Property ' .. key .. ' is readonly.')
	end
end 

setmetatable(class, classMeta)

print('===== Class Before New Class =====')
print('Class    : ' .. class.classname)
print('Instance : ' .. class.instanceID)

local xnewCls = class('abcd')

print('')
print('===== Class After New Class =====')
print('Class    : ' .. class.classname)
print('Instance : ' .. class.instanceID)

print('')
print('===== New Class =====')
print('Class    : ' .. xnewCls.classname)
print('Instance : ' .. xnewCls.instanceID)

local newCls = xnewCls('aaa')

print('')
print('===== Class After New Instance =====')
print('Class    : ' .. class.classname)
print('Instance : ' .. class.instanceID)

print('')
print('===== New Class After New Instance =====')
print('Class    : ' .. xnewCls.classname)
print('Instance : ' .. xnewCls.instanceID)


print('')
print('===== New Instance =====')
for key, itm in pairs(newCls) do
	print(key)
end
print('Class    : ' .. newCls.classname)
print('Instance : ' .. newCls.instanceID)

-- copy.OneTwoMany ='Two much to handle'

-- print(newCls.OneTwoMany)

--scriptExit()

xnewCls:addProperty('OneTwoMany', 'This is easy peasy!')

print('===== Intact Meta Property just set=====')
print(newCls.OneTwoMany)
print(newCls.classname)
print(newCls.instanceID)

newCls.OneTwoMany = 'One too hard'

print('===== Intact Meta Property changed =====')
print(newCls.OneTwoMany)
print(newCls.classname)	
print(newCls.instanceID)

newCls = setmetatable(getmetatable(newCls), {})

print('===== Base only =====')
print(newCls.OneTwoMany)
print(newCls.classname)
print(newCls.instanceID)

-- local newCls = {classname = 'classMeta'}
-- newCls.__index = function(tbl, key)
	-- local value = rawget(tbl, key)
	-- assert(value~=nil, 'Invalid property ' .. key)
	-- return value 
-- end

-- setmetatable(newCls, classMeta)
