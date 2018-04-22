function newClass(typ, global)
	local baseMeta = {}
	baseMeta.__index = baseMeta
	
	
	local base = {}
	
	assert(typ~=nil, "Type is required")
	assert(typeOf(typ)=='string', "Enter string in type")	
	
	base.Type 		= typ:lower()
	base.isGlobal = global or false
	
	
	addType(base)
	
	return setmetatable(base, baseMeta)
end

__jAGRequire = require

function addType(obj)
	if _G['jAGTypes'] == nil then
		_G['jAGTypes'] = {}
	end
	
	local utyp = obj.Type:upper()	
	local ltyp = obj.Type:lower()
	_G['req' .. utyp] = function()
		local req = nil
		if obj.isGlobal then
			if _G[utyp] == nil then
				_G[utyp] = __jAGRequire(ltyp)
			end
			req = _G[utyp]
		else
			req = __jAGRequire(ltyp)
		end		
		return req
	end
	
	jAGTypes[utyp] = ltyp
	
	obj.typeOf = function(self)
		return typeOf(self)
	end
	
	return obj 
end

__jAGTypeOf = typeOf

function typeOf(obj)
	local typ = nil
	if obj ~= nil then
		if obj['Type'] == nil then
			typ = __jAGTypeOf(obj)
		else
			typ = obj.Type
		end
	end
	return typ
end

function require(moduleName)
	assert(moduleName, 'Enter moduleName')
	local reqo = _G['req' .. moduleName:upper()] or __jAGRequire(moduleName:lower())	
	return reqo
end