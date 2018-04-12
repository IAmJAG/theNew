local baseMeta = {}
baseMeta.__index = baseMeta

function baseMeta:new(typ, global)
	local base = {}
	setmetatable(base, self)
	assert(typ~=nil, "Type is required")
	assert(typeOf(typ)=='string', "Enter string in type")
	base.Type 		= typ:lower()
	base.isGlobal = global or false
	base:addType()
	return base
end

function baseMeta:typeOf()
	return typeOf(self)
end

__jAGRequire = require

function baseMeta:addType()
	if _G['jAGTypes'] == nil then
		_G['jAGTypes'] = {}
	end
	
	local utyp = self.Type:upper()	
	local ltyp = self.Type:lower()
	_G['req' .. utyp] = function()
		local req = nil
		if self.isGlobal then
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

return baseMeta