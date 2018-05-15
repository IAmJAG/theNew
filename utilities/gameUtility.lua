class('gameUtility')

if trace == nil then
	trace = function(...) 
		return 0
		--print(...) 
	end
end

__typeOf = typeOf

__setImagePath = setImagePath

setImagePath = function(path)
	__setImagePath(path)
	currentImagePath = path
end

getImagePath = function()
	return currentImagePath .. "/"
end

typeOf = function(self)
	local typ = __typeOf(self)
	if typ == 'table'  then
		if self['typeOf'] ~= nil then
			typ = self:typeOf()
		end
	end
	
	return typ
end

type = typeOf

local scrPath = scriptPath()

gameutility.imagePath			= scrPath .. 'images'
gameutility.OCRPath				= scrPath .. 'images/OCR'
gameutility.scriptPath		= scrPath

function gameutility:patternToLocation(pttrn)
	local rgn = pttrn:getRegion()
	local loc = nil
	if rgn then
		local locY = tonumber(string.format('%d', rgn:getY() + (rgn:getH()/2)))
		local locX = tonumber(string.format('%d', rgn:getX() + (rgn:getW()/2)))

		loc = location()
		loc.x = locX
		loc.y = locY
	else
		Debug('Pattern must be present in the screen to convert pattern to location')
	end
	
	return loc
end

function gameutility:ms()
	return tonumber(string.format("%.0f", os.clock() * 1000))			
end

-- function gameutility:convertToType(dta, typ)
	-- local obj = {}
	-- if typ ~= nil then
		-- obj = _G[typ]()
	-- end
	
	-- for k, o in pairs(dta) do
		-- typ = self:typeOf(dta[k])
		-- trace('Converting type ' .. typ)
		-- obj[k] = self:convert(o, typ)
	-- end
	
	-- return obj
-- end

-- function gameUtility:convertToObject(dta)
	-- local obj = {}	
	-- for k, o in ipairs(dta) do		
		-- obj[k] = self:convert(o, self:typeOf(obj[k]))
	-- end	
	-- return obj
-- end

-- function gameUtility:convertToArray(dta)
	-- local obj = {}	
	-- for k, o in pairs(dta) do		
		-- obj[k] = self:convert(o, self:typeOf(obj[k]))
	-- end	
	-- return obj
-- end

-- function gameUtility:convert(o, typ)
	-- local obj 
	-- if typ == 'string' then
		-- obj = o
	-- elseif typ == 'number' then
		-- obj = o
	-- elseif typ == 'boolean' then
		-- obj = o
	-- elseif typ == 'array' then
		-- obj = self:convertToArray(o)
	-- elseif typ == 'object' then
		-- obj = self:convertToObject(o)
	-- else
		-- if o['Type'] ~= nil then
			-- obj = self:convertToType(o, o.Type)
		-- else
			-- Debug('Type not recognize ' .. typ)
			-- obj = o
		-- end
	-- end
	-- trace('Convert type ' .. typ)
	-- return obj
-- end	

-- function gameUtility:saveJSON(j, filePath)
	-- local strJSON
	-- if self:typeOf(j) == 'string' then
		-- strJSON = self:encodeJSON(self:decodeJSON(j), minifyJSONSave)
	-- else
		-- strJSON = self:encodeJSON(j, minifyJSONSave)
	-- end
	-- trace('writting to ' .. filePath)
	-- local fp = io.open(filePath, "w")
	-- fp:write(strJSON)
	-- fp:close()
-- end

-- function gameUtility:readJSON(filePath, typ)
	-- local strJSON = self:readFile(filePath)
	-- local obj = self:decodeJSON(strJSON, typ)
	-- return obj
-- end

function gameutility.tbl_toString(t, name, indent)
	table.show = function(t, name, indent)
		local cart -- a container
		local autoref -- for self references

		--[[ counts the number of elements in a table
		local function tablecount(t)
			 local n = 0
			 for _, _ in pairs(t) do n = n+1 end
			 return n
		end
		]]
		-- (RiciLake) returns true if the table is empty
		local function isemptytable(t) return next(t) == nil end

		local function basicSerialize(o)
				local so = tostring(o)
				if typeOf(o) == "function" then
						local info = debug.getinfo(o, "S")
						-- info.name is nil because o is not a calling level
						if info.what == "C" then
								return string.format("%q", so .. ", C function")
						else
								-- the information is defined through lines
								return string.format("%q", so .. ", defined in (" ..
												info.linedefined .. "-" .. info.lastlinedefined ..
												")" .. info.source)
						end
				elseif typeOf(o) == "number" or typeOf(o) == "boolean" then
						return so
				else
						return string.format("%q", so)
				end
		end

		local function addtocart(value, name, indent, saved, field)
				indent = indent or ""
				saved = saved or {}
				field = field or name

				cart = cart .. indent .. field

				if typeOf(value) ~= "table" then
						cart = cart .. " = " .. basicSerialize(value) .. ";\n"
				else
						if saved[value] then
								cart = cart .. " = {}; -- " .. saved[value]
												.. " (self reference)\n"
								autoref = autoref .. name .. " = " .. saved[value] .. ";\n"
						else
								saved[value] = name
								--if tablecount(value) == 0 then
								if isemptytable(value) then
										cart = cart .. " = {};\n"
								else
										cart = cart .. " = {\n"
										for k, v in pairs(value) do
												k = basicSerialize(k)
												local fname = string.format("%s[%s]", name, k)
												field = string.format("[%s]", k)
												-- three spaces between levels
												addtocart(v, fname, indent .. "   ", saved, field)
										end
										cart = cart .. indent .. "};\n"
								end
						end
				end
		end

		name = name or "__unnamed__"
		if typeOf(t) ~= "table" then
				return name .. " = " .. basicSerialize(t)
		end
		cart, autoref = "", ""
		addtocart(t, name, indent)
		return cart .. autoref
	end
	return table.show(t, name, indent)
end

function gameutility:fileExist(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function gameutility:readFile(file)
  if not self:fileExist(file) then return '' end
  lines = ''
  for line in io.lines(file) do 
    lines = lines .. line .. '\n' 
  end
  return lines
end

function gameutility:scanDirectory(dir, ext)
	local listFile = dir .. "/files.lst"
	ext = ext or "*";
	local query = dir .. "/*." .. ext
	local command = "ls " .. query .. " > " .. listFile
  os.execute(command)
  local lines = {}
  local i = 1
  for line in io.lines(listFile) do
		lines[#lines + 1] = line
  end
  return lines
end

_G['GU'] = gameutility()