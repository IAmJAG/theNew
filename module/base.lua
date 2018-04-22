--================= CLASS ================--
local baseIndex =  function(tbl, key)
    local base = getmetatable(tbl)
    
    local props = rawget(base, '_data')
    
    local ret = props[key]
    if ret == nil then
        local meths = rawget(base, '_methods')
        ret = meths[key]        
    end

    if ret == nil then
        ret = base[key]
    end
    
    return ret
end

local baseNewIndex = function(tbl, key, newValue)
    local base = getmetatable(tbl)
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
    
    assert(tbl[key]~=nil, 'Member not found!')
    
    if type(newValue) == 'function' then
        local meths = rawget(base, '_methods')
        meths[key] = newValue
    else
        local props = rawget(base, '_data')
        props[key] = newValue
    end
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
    local clsBase = getmetatable(tbl)
    local clsid = tbl._id
    local instanceid = 1
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
    
    local base = {    _id = clsid
                    , _instanceid = instanceid
                    , _data = newData
                    , _methods = newMethods
                    , __index = baseIndex
                    , __newindex = classNewIndex
    }
    
    local proxy = {_id = 'proxy'}
    
    setmetatable(base, getmetatable(clsBase))
    
    return setmetatable(proxy, base)
end

class = {_id = 'base', _data = {}, _methods = {}}      -- our object
class.__index = baseIndex

local root = { _id = 'root', _instances = {}, 
        __index = function (tbl, key)
            local meta = getmetatable(tbl)
            return rawget(meta, key)
        end,
        __newindex = function(tbl, key, newValue)
            print('New member request from root!')
        end
}

root.__call = function(tbl, key)
    assert(key~=nil, 'Class ID is required!')
    assert(key~='', 'Class ID is required!')
    
    local clsid = key:lower()
    local base = {    _id = clsid
                    , _data = {}
                    , _methods = {}
                    , __index = baseIndex
                    , __newindex = baseNewIndex
                    , __call = classCall
    }
    
    local proxy = {_id = 'proxy'}
    
    setmetatable(base, getmetatable(tbl))
    
    return setmetatable(proxy, base)
end

setmetatable(class, root)

function root:typeOf()
	return typeOf(self)
end

__jAGTypeOf = typeOf

function typeOf(obj)
	local typ = nil
	if obj ~= nil then
		if obj['_id'] == nil then
			typ = __jAGTypeOf(obj)
		else
			typ = obj._id
		end
	end
	return typ
end

function require(moduleName)
	assert(moduleName, 'Enter moduleName')
	local reqo = _G['req' .. moduleName:upper()] or __jAGRequire(moduleName:lower())	
	return reqo
end

return meta