class('dictionary')

dictionary.itemType = false
dictionary.items		= {}

function dictionary:addItem(itm, key)
	self.itemType =  self.itemType or typeOf(itm) 
	assert(typeOf(itm) == self.itemType, 'Invalid type!')
	key = key or self:count()+1
	self.items[key] = itm
end

function dictionary:count()
	local cnt = 0
	for key, itm in pairs(self.items) do
		cnt = cnt + 1
	end
	return cnt
end

function dictionary:getItem(key)
	return self.items[key]
end

function dictionary:removeItem(key)
	self.items[key] = nil
end