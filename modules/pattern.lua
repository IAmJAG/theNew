class('pattern')

pattern.fileName 	= ''
pattern.isIndexed = false
pattern.regions		= {}

function pattern:getPattern()
	assert(self.fileName ~= '', 'Pattern is not initialized')
	
	if _G['PATTERNS'] == nil then
		_G['PATTERNS'] = {}
	end
	
	if not self.isIndexed then
		PATTERNS[self.fileName] = Pattern(self.fileName)
		self.isIndexed = true	
	end
	
	return PATTERNS[self.fileName]
end

function pattern:click()
	local rgn 	= region()
	local pat 	= self:getPattern()
	rgn:click(pat)
	self:addRegion()
end

function pattern:getRegion()
	local rgn = nil
	for w, widths in pairs(self.regions) do
		for h, heights in pairs(widths) do
			for x, xs in pairs(heights) do
				for y, rgn in pairs(xs) do
					if rgn:exists(self.fileName) then 
						break	
					end
				end
			end
		end
	end
	
	if not rgn then
		if region():exists(self.fileName) then
			rgn = self:addRegion()
		end
	end
	
	return rgn
end

function pattern:exists()
	local exsts = false 
	
	for w, widths in pairs(self.regions) do
		for h, heights in pairs(widths) do
			for x, xs in pairs(heights) do
				for y, rgn in pairs(xs) do
					exsts = rgn:exists(self.fileName)
					if exsts then break	end
				end
			end
		end
	end
	
	if not exsts then
		local rgn = region()
		local exsts 	= rgn:exists(self.fileName)
		self:addRegion()
	end
	
	return exsts
end

function pattern:addRegion()
	local match = rgn:getLastMatch()
	
	if self.regions[match.w] == nil then
		self.regions[match.w] = {}
	end
	
	if self.regions[match.w][match.h] == nil then
		self.regions[match.w][match.h] = {}
	end		
	
	if self.regions[match.w][match.h][match.x] == nil then
		self.regions[match.w][match.h][match.x] = {}
	end		
	
	if self.regions[match.w][match.h][match.x][match.y] == nil then
		self.regions[match.w][match.h][match.x][match.y] = Region(match.x, match.y, match.w, match.h)
	end
	
	return self.regions[match.w][match.h][match.x][match.y]
end