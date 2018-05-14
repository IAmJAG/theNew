--=============== Status Bar ===============--
class('region')

if SCR == nil then
	SCR = getAppUsableScreenSize()
end

region.x 		= 0
region.y 		= 0
region.w = SCR:getX()
region.h = SCR:getY()
region.isIndexed = false

function region:encode()
	local base = getmetatable(self)
	local _data = rawget(base, '_data')
	_data.isIndexed = false
	_data.type = self:typeOf()
	return self.json:encode(_data)
end

function region:getRegion()
	if not self.isIndexed then
		self:GIndex()
	end
	
	local rgn = _G['REGIONS'][self.w][self.h][self.x][self.y]
	return rgn
end

function region:GIndex()
	self.x = tonumber(self.x)
	self.y = tonumber(self.y)
	self.w = tonumber(self.w)
	self.h = tonumber(self.h)
	if _G['REGIONS'] == nil then	
		_G['REGIONS'] = {}
	end
	
	if _G['REGIONS'][self.w] == nil then
		_G['REGIONS'][self.w] = {}
	end
	
	if _G['REGIONS'][self.w][self.h] == nil then
		_G['REGIONS'][self.w][self.h] = {}
	end		
	
	if _G['REGIONS'][self.w][self.h][self.x] == nil then
		_G['REGIONS'][self.w][self.h][self.x] = {}
	end		
	
	if _G['REGIONS'][self.w][self.h][self.x][self.y] == nil then
		_G['REGIONS'][self.w][self.h][self.x][self.y] = Region(self.x, self.y, self.w, self.h)
	else
		_G['REGIONS'][self.w][self.h][self.x][self.y] = Region(self.x, self.y, self.w, self.h)
	end
	self.isIndexed = true
end

function region:click(pat)
	local rgn = self:getRegion()
	--print(self.isIndexed, rgn, pat)
	rgn:click(pat)
end

function region:save(fName, imagePath)
	local rgn 	= self:getRegion()
	imagePath 	= imagePath or currentImagePath
	prevImgPath = currentImagePath
	setImagePath(imagePath)
	rgn:save(fName)
	setImagePath(prevImgPath)
end

function region:getLastMatch()
	local rgn = self:getRegion()
	return rgn:getLastMatch()
end

function region:exists(pat)
	local rgn = self:getRegion()
	return rgn:exists(pat)
end

function region:save(fname)
	local rgn = self:getRegion()
	return rgn:save(fname)
end

function region:getX()
	return self.x
end

function region:getY()
	return self.y
end

function region:getW()
	return self.w
end

function region:getH()
	return self.h
end