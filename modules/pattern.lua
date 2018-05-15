class('pattern')

pattern.fileName 	= ''
pattern.isIndexed = false
pattern.regions		= dictionary()
pattern.minimized	= false
pattern.minimizePath = ""

function pattern:minimize()	
	local curImgPath = getImagePath()
	setImagePath(self.minimizePath)
	
	local rgn = self:getRegion()
	
	if rgn ~= nil then
		if rgn.w > 20 then
			rgn.w = 20
			rgn.x = rgn.x + ((rgn.w - 20)/2)
		end
		
		if rgn.h > 20 then
			rgn.h = 20
			rgn.y = rgn.y + ((rgn.y - 20)/2)
		end
		
		rgn:save(self.fileName)
	end
	setImagePath(curImgPath)
	self.minimized = true
end

function pattern:setMinimizedPath(path)
	self.minimizePath = path
end

function pattern:encode()
	local base = getmetatable(self)
	local _data = rawget(base, '_data')
	_data.isIndexed = false	
	_data.type = self:typeOf()
	return self.json:encode(_data)
end

function pattern:getPattern()
	if not self.isIndexed then
		self:GIndex()
		--self:minimize()
	end
	return PATTERNS[self.fileName]
end

function pattern:GIndex()
	assert(self.fileName ~= '', 'Pattern is not initialized')
	
	if _G['PATTERNS'] == nil then
		_G['PATTERNS'] = {}
	end
	
	PATTERNS[self.fileName] = Pattern(self.fileName)
	self.isIndexed = true	
end

function pattern:click()
	local pat 	= self:getPattern()	
	--print(pat)
	local rgn 	= self:getRegion()
	if rgn == nil then
		rgn = region()
		rgn:click(pat)
		self:addRegion(rgn)
	else
		rgn:click(pat)
	end		
end

function pattern:getRegion()
	local xrgn = nil
	for mtchStr, rgn in pairs(self.regions.items) do
		if rgn:exists(self.fileName) then 
			xrgn = rgn
			break	
		end
	end	
	return xrgn
end

function pattern:exists()
	local rgn = pattern:getRegion()
	local exsts = (rgn ~= nil)
	
	if not exsts then
		rgn 		= region()
		exsts 	= rgn:exists(self.fileName) ~= nil
		if exsts then
			self:addRegion(rgn)
		end
	end
	return exsts
end

function pattern:addRegion(rgn)
	local xmatch = rgn:getLastMatch()
	local match = {x = xmatch:getX(), y = xmatch:getY(), w = xmatch:getW(), h = xmatch:getH()}
	local itm = nil
	
	if match ~= nil then	
		local mtchStr = tostring(match.w) .. "|" .. tostring(match.h) .. "|" .. tostring(match.x) .. "|" .. tostring(match.y)	
		
		itm = self.regions:getItem(mtchStr)
		
		if itm == nil then
			local rgn = region()			
			rgn.x = match.x
			rgn.y = match.y
			rgn.w = match.w
			rgn.h = match.h
			itm = self.regions:addItem(rgn, mtchStr)
			rgn:GIndex()
		end	
	end
	
	return itm
end