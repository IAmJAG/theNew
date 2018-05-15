--=============== Status Bar ===============--
class('region')

if SCR == nil then
	SCR = getAppUsableScreenSize()
end

region.x 		= 0
region.y 		= 0
statusbar.w = SCR:getX()
statusbar.h = SCR:getY()
region.isIndexed = false

function region:getRegion()
	if not self.isIndexed then
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
		end
		region.isIndexed = true
	end
	
	return _G['REGIONS'][self.w][self.h][self.x][self.y]
end

function region:click()
	local rgn = self:getRegion()
	rgn:click()
end

function region:save(fName, imagePath)
	local rgn 	= self:getRegion()
	imagePath 	= imagePath or currentImagePath
	prevImgPath = currentImagePath
	setImagePath(imagePath)
	rgn:save(fName)
	setImagePath(prevImgPath)
end

function region:exist(pat)
	local p = pat:getPattern()
	local rgn = self:getRegion()
	
	return rgn:exist(p)
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