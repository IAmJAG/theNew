--=============== Status Bar ===============--
class('location')

location.x = 0
location.y = 0
location.isIndexed = false

function location:encode()
	local base = getmetatable(self)
	local _data = rawget(base, '_data')
	_data.isIndexed = false	
	_data.type = self:typeOf()
	return self.json:encode(_data)
end

function location:getLocation()
	if not self.isIndexed then
		self.x = tonumber(self.x)
		self.y = tonumber(self.y)
		
		if _G['LOCATIONS'] == nil then
			_G['LOCATIONS'] = {}
		end
		
		if _G['LOCATIONS'][self.x] == nil then
			_G['LOCATIONS'][self.x] = {}
		end
		
		if _G['LOCATIONS'][self.x][self.y] == nil then
			_G['LOCATIONS'][self.x][self.y] = Location(self.x, self.y)
		end		
		
		location.isIndexed = true
	end
	
	return LOCATIONS[self.x][self.y]
end

function location:click()
	local loc = self:getLocation()
	click(loc)
end

function location:getX()
	return self.x
end

function location:getY()
	return self.y
end