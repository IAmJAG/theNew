--=============== Status Bar
local statusBar = require('base')

if SCR == nil then
	SCR = getAppUsableScreenSize()
end

function statusBar.create(x, y, w, h)
	local bar = statusBar:new('statusBar', true)
	
	bar.x 			 	= x or 0
	bar.y 			 	= y or 0
	bar.w 			 	= w or SCR:getW()
	bar.h 			 	= h or SCR:getH()
								
	bar.barColor 	= gray
	bar.bar			 	= Region(bar.x, bar.y, bar.w, bar.h)
	bar.sections	= {}
	
	return bar
end

function statusBar:show()
	self.bar = self.bar or Region(self.x, self.y, self.w, self.h)
	setHighlightStyle(self.barColor, false)
	self.bar:highlight()
	for i, sec in pairs(self.sections) do
		sec:show(self)
	end
end

function statusBar:hide()
	for i, sec in pairs(self.sections) do
		sec:hide()
	end
	self.bar:highlightOff()
end

function statusBar:addSection(sectionTyp, x, y, w, h)
	x 	= x or self.x
	y 	= y or self.y
	w 	= w or self.w
	h 	= h or self.h	
	local newSection = require(sectionTyp).create(x, y, w, h)	
	self.sections[#self.sections+1] = newSection
end


colors = {
	green = 0xFF709E00;
	blue = 0xFF1F91C2;
	orange = 0xFFCF5200;
	red = 0xFFBC1000;
	purple = 0xFF6C0083;
	--
	green_dark = 0xFF577B00;
	blue_dark = 0xFF187197;
	orange_dark = 0xFFA14000;
	red_dark = 0xFF920D00;
	purple_dark = 0xFF540066;
	--
	white = 0xFFF4F6F6;
	black = 0xFF2A2A27;
	gray = 0xFF464742;
	gray_light = 0xFF6D6E6A;
	--
	transparent = 0x00FFFFFF;
}

return statusBar