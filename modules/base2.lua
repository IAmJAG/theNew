--================ Base ================--

-- the base will be the readonly data table
base = {
	className = 'base',
	instanceName = 'xxx',
	
	new=function(self, t)
		t = t or {}			-- this will define the data table
		for _, itm in pairs(t) do
			assert(typeOf(itm) ~= 'function', 'Define your function after the class declaration.')
		end
		return setmetatable(t, {__index = self})
	end,
}

-- holds the methods
methods = {
	methods = 'Methods',
	getClassName=function(self)
			return self.className
	end,
	getInstanceName=function(self)
			return self.instanceName
	end,
	
	
	inherit=function (self,t,methods)		
		t.base = self
		local mtnew={__index = setmetatable(methods, {__index = self})}
		return setmetatable(t or {},mtnew)
	end	
}
	
mtClass={}
mtClass.__index=methods

mtClass.__call = function(t, clsNm)
	x = { datatable = 'datatable'}
	return t:new(x)
end
setmetatable(base, mtClass)

--==== Meta table scope
local zbase = base('ZZZZZZ')

print(zbase.methods)

local newMT = getmetatable(zbase)
newMT.methods = 'changed'

print(zbase.methods)


-- print '===== zbase ====='
-- print('Methods          1 ' .. zbase.methods)
-- print('dataReadOnly 1 ' .. zbase.dataReadOnly)
-- print('datatable         1 ' .. zbase.datatable)

-- local metaOne = getmetatable(zbase).__index

-- print ''

-- print '===== metaone ====='
-- print('Methods          1 ' .. metaOne.methods)
-- print('dataReadOnly 1 ' .. metaOne.dataReadOnly)
-- --print('datatable         1 ' .. metaOne.datatable)

-- local metaTwo = getmetatable(metaOne).__index

-- print ''

-- print '===== metaTwo ====='
-- print('Methods          1 ' .. metaTwo.methods)


-- print(base.className)
-- print(base.instanceName)

-- local xbase = base:new({className = 'xxxxxx', instanceName = 'yyyyyyy'})

-- print(xbase.className)
-- print(xbase.instanceName)

-- local ybase = xbase:inherit({}, {})

-- print(ybase.className)
-- print(ybase.instanceName)



-- function newClass(typ, global)
	-- local baseMeta = {}
	-- baseMeta.__index = baseMeta
	
	
	-- local base = {}
	
	-- assert(typ~=nil, "Type is required")
	-- assert(typeOf(typ)=='string', "Enter string in type")	
	
	-- base.Type 		= typ:lower()
	-- base.isGlobal = global or false
	
	
	-- addType(base)
	
	-- return setmetatable(base, baseMeta)
-- end

-- __jAGRequire = require

-- function addType(obj)
	-- if _G['jAGTypes'] == nil then
		-- _G['jAGTypes'] = {}
	-- end
	
	-- local utyp = obj.Type:upper()	
	-- local ltyp = obj.Type:lower()
	-- _G['req' .. utyp] = function()
		-- local req = nil
		-- if obj.isGlobal then
			-- if _G[utyp] == nil then
				-- _G[utyp] = __jAGRequire(ltyp)
			-- end
			-- req = _G[utyp]
		-- else
			-- req = __jAGRequire(ltyp)
		-- end		
		-- return req
	-- end
	
	-- jAGTypes[utyp] = ltyp
	
	-- obj.typeOf = function(self)
		-- return typeOf(self)
	-- end
	
	-- return obj 
-- end

-- __jAGTypeOf = typeOf

-- function typeOf(obj)
	-- local typ = nil
	-- if obj ~= nil then
		-- if obj['Type'] == nil then
			-- typ = __jAGTypeOf(obj)
		-- else
			-- typ = obj.Type
		-- end
	-- end
	-- return typ
-- end

-- function require(moduleName)
	-- assert(moduleName, 'Enter moduleName')
	-- local reqo = _G['req' .. moduleName:upper()] or __jAGRequire(moduleName:lower())	
	-- return reqo
-- end